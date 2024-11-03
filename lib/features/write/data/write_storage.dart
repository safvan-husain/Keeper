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
    List<String> words = ["safvan", "good", "nice", "when", "really"];

    for (var w in words) {
      saveWord(w);
    }
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

  int saveWord(String word) {
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
      int id = _characterBox.put(node);
      node = node..id = id;
      characters.add(node);
    }

    Node nextNode = characters.last;
    for (int i = characters.length - 2; i >= index; i--) {
      characters[i].children.add(nextNode);
      nextNode = characters[i];
      _characterBox.put(nextNode);
    }

    return characters.last.id;
  }

  void seeAll() async {
    var query = _characterBox.query().build();

    var result = await query.findAsync();

    print(result
        .map((e) => "${e.char} child: ${e.children.map((k) => k.char)}")
        .toList());
  }

  void deleteALl() async {
    await _characterBox.removeAllAsync();
    seeAll();
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
}
