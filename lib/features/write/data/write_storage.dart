import 'package:keeper/features/write/domain/entity/predicted_word.dart';
import 'package:objectbox/objectbox.dart';
import '../../../objectbox.g.dart';
import '../domain/entity/chacter_node.dart';
import '../domain/entity/journal.dart';

class WriteStorage {
  final String _rootChar = "root";
  late Node _rootNode;
  Store? _store;
  late final Box<Node> _characterBox;
  late final Box<Journal> _journalBox;

  //using in on null case for firstWhere method.
  final Node none = Node(char: "none");

  Future<void> init() async {
    _store ??= await openStore();
    _characterBox = _store!.box<Node>();
    _journalBox = _store!.box<Journal>();

    _initRootNode();
  }

  void _initRootNode() {
    final query = _characterBox // Query
        .query(Node_.char.equals(_rootChar))
        .build();
    final List<Node> nodes = query.find();
    query.close();
    if (nodes.isEmpty) {
      _rootNode = Node(char: _rootChar);
      final int id = _characterBox.put(_rootNode);
      _rootNode = _rootNode..id = id;
    } else {
      _rootNode = nodes.first;
    }
  }

  Stream<List<Journal>> subscribe() {
    return _journalBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Future<int> _saveWord(String word) async {
    Node prevNode = _rootNode;

    List<Node> characters = [];

    bool foundEnd = false;
    int index = 0;
    characters.add(_rootNode);
    // Node previousNode = prevNode;

    while (!foundEnd) {
      bool last = index == word.length - 1;
      Node tempNode = prevNode.children.firstWhere(
          (node) => node.char == word.substring(index, index + 1),
          orElse: () => none);
      if (tempNode.char == none.char) {
        foundEnd = true;
        break;
      } else {
        index++;
        if (last) {
          tempNode = tempNode..isEnd = true;
          characters.add(tempNode);
          prevNode = tempNode;
          break;
        }
        characters.add(tempNode);
        prevNode = tempNode;
      }
    }

    for (int i = index; i < word.length; i++) {
      Node node = Node(char: word[i], isEnd: i == word.length - 1);
      //assigning parent character relation.
      node.parent.target = characters.lastOrNull;
      int id = await _characterBox.putAsync(node);
      node = node..id = id;
      characters.add(node);
    }

    Node nextNode = characters.last;
    for (int i = characters.length - 2; i >= index; i--) {
      characters[i].children.add(nextNode);
      nextNode = characters[i];
      await _characterBox.putAsync(nextNode);
    }

    return characters.last.id;
  }

  void seeAll() async {
    // var query = _characterBox.query().build();
    //
    // var result = await query.findAsync();
    //
    // print(result
    //     .map((e) => "${e.char} child: ${e.children.map((k) => k.char)}")
    //     .toList());
    // query.close();

    var query2 = _journalBox.query().build();

    var result2 = await query2.findAsync();
    print(result2);
  }

  void deleteALl() async {
    await _journalBox.removeAllAsync();
    await _characterBox.removeAllAsync();
    seeAll();
  }

  Future<int> saveJournal({
    required String content,
    required Journal journal,
  }) async {
    if (journal.content.isNotEmpty) {
      //for avoiding multiple association
      await _unMarkTokenUsedIn(journal);
    }
    List<String> tokens = content.split(" ");
    List<int> codeContent = [];
    for (var token in tokens) {
      var code = await _saveWord(token);
      codeContent.add(code);
    }

    var journalId = _journalBox.put(
      journal..content = codeContent,
    );

    _markTokenUsedOn(
      tokens: codeContent,
      journalId: journalId,
    );

    return journalId;
  }

  void _markTokenUsedOn({
    required List<int> tokens,
    required int journalId,
  }) async {
    Query<Node>? query;
    Condition<Node>? condition;
    for (var token in tokens) {
      condition =
          condition?.or(Node_.id.equals(token)) ?? Node_.id.equals(token);
    }
    query = _characterBox.query(condition).build();
    var result = await query.findAsync();

    for (var node in result) {
      node.usedPages.add(journalId);
      _characterBox.putAsync(node);
    }
    query.close();
  }

  List<String> predictWord(String prompt) {
    if (prompt.length < 2) return [];
    List<String> possibleWords = [];
    Node prevNode = _rootNode;

    bool reachLast = false;

    int index = 0;

    while (!reachLast) {
      reachLast = index == prompt.length - 1;

      Node tempNode = prevNode.children.firstWhere(
          (node) => node.char == prompt.substring(index, index + 1),
          orElse: () => none);
      if (tempNode.char == none.char) {
        if (!reachLast) return [];
        break;
      } else {
        prevNode = tempNode;
        index++;
      }
    }

    List<String> result = [];
    _collectPossibleWords(prevNode, "", result);

    return result.map((e) => e.substring(1)).toList();
  }

  void _collectPossibleWords(Node node, String text, List<String> results) {
    if (node.isEnd) {
      results.add(text + node.char);
    }
    for (var child in node.children) {
      _collectPossibleWords(child, text + node.char, results);
    }
  }

  Future<String> decodeContent(Journal journal) async {
    var futureContent = journal.content.map((e) async {
      var query = _characterBox.query(Node_.id.equals(e)).build();
      var result = await query.findAsync();
      Node node = result.first;
      return node.getWord();
    }).toList();
    var content = await Future.wait(futureContent);
    return content.join(" ");
  }

  Future<void> _unMarkTokenUsedIn(Journal journal) async {
    for (var e in journal.content) {
      var query = _characterBox.query(Node_.id.equals(e)).build();
      var result = await query.findAsync();
      for (var e in result) {
        e.usedPages.removeWhere((k) => k == journal.id);
        await _characterBox.putAsync(e);
      }
    }
  }
}
