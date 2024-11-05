import '../features/write/domain/entity/chacter_node.dart';
import '../features/write/domain/entity/journal.dart';
import '../objectbox.g.dart';

class AppStorage {
  final String _rootChar = "root";
  late Node _rootNode;
  Store? _store;
  late final Box<Node> _characterBox;
  late final Box<Journal> _journalBox;

  //using in on null case for firstWhere method.
  final Node _none = Node(char: "none");

  String get rootChar => _rootChar;

  Node get rootNode => _rootNode;

  Box<Node> get characterBox => _characterBox;

  Box<Journal> get journalBox => _journalBox;

  Node get none => _none;

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

  List<String> predictWord(String prompt) {
    if (prompt.length < 2) return [];
    List<String> possibleWords = [];
    Node prevNode = rootNode;

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

  Future<int> saveWord(String word) async {
    Node prevNode = rootNode;

    List<Node> characters = [];

    bool foundEnd = false;
    int index = 0;
    characters.add(rootNode);
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
      int id = await characterBox.putAsync(node);
      node = node..id = id;
      characters.add(node);
    }

    Node nextNode = characters.last;
    for (int i = characters.length - 2; i >= index; i--) {
      characters[i].children.add(nextNode);
      nextNode = characters[i];
      await characterBox.putAsync(nextNode);
    }

    return characters.last.id;
  }
}
