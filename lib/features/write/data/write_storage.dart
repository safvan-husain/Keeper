import 'package:keeper/features/write/domain/entity/predicted_word.dart';
import 'package:objectbox/objectbox.dart';
import '../../../objectbox.g.dart';

@Entity()
class Node {
  @Id()
  int id;
  String char;
  bool isEnd;
  ToMany<Node> children = ToMany<Node>();

  Node({
    this.id = 0,
    this.isEnd = false,
    required this.char,
  });

  @override
  String toString() {
    return "$char -> ${children.isNotEmpty ? children.map((e) => e.toString).toList() : "no child"}";
  }
}

class WriteStorage {
  String rootChar = "root";
  late Node rootNode;
  Store? _store;
  late final Box<Node> box;

  //using in on null case for firstWhere method.
  final Node none = Node(char: "none");

  Future<void> init() async {
    print("initilazing storage");
    _store ??= await openStore();
    box = _store!.box<Node>();
    final query = box // Query
        .query(Node_.char.equals(rootChar))
        .build();
    final List<Node> nodes = query.find();
    query.close();
    if (nodes.isEmpty) {
      rootNode = Node(char: rootChar);
      final int id = box.put(rootNode);
      rootNode = rootNode..id = id;
    } else {
      rootNode = nodes.first;
    }
  }

  int saveWord(String word) {
    Node prevNode = rootNode;

    List<Node> charecters = [];

    bool foundEnd = false;
    int index = 0;
    charecters.add(rootNode);
    // Node previousNode = prevNode;

    while (!foundEnd) {
      bool last = index == word.length - 1;
      print("looking for node ${word.substring(index, index + 1)}");
      Node tempNode = prevNode.children.firstWhere(
          (node) => node.char == word.substring(index, index + 1),
          orElse: () => none);
      print("not found end yet ${tempNode.char}");
      if (tempNode.char == none.char) {
        foundEnd = true;
        break;
      } else {
        index++;
        if (last) {
          tempNode = tempNode..isEnd = true;
          charecters.add(tempNode);
          prevNode = tempNode;
          break;
        }
        charecters.add(tempNode);
        prevNode = tempNode;
      }
    }

    print("before adding new ${prevNode.toString()}");

    for (int i = index; i < word.length; i++) {
      print("for adding new char for ${word[i]}");
      Node node = Node(char: word[i], isEnd: i == word.length - 1);
      int id = box.put(node);
      node = node..id = id;
      charecters.add(node);
    }

    Node nextNode = charecters.last;
    for (int i = charecters.length - 2; i >= index; i--) {
      charecters[i].children.add(nextNode);
      nextNode = charecters[i];
      box.put(nextNode);
    }

    return charecters.last.id;
  }

  void seeAll() async {
    var query = box.query().build();

    var result = await query.findAsync();

    print(result
        .map((e) => "${e.char} childs: ${e.children.map((k) => "${k.char}")}")
        .toList());
  }

  void deleteALl() async {
    await box.removeAllAsync();
    seeAll();
  }

  List<PredictedWord> predictWord(String prompt) {
    print("predicting for $prompt");
    List<PredictedWord> possibleWords = [];
    Node prevNode = rootNode;

    bool reachLast = false;

    int index = 0;

    while (!reachLast) {
      reachLast = index == prompt.length - 1;

      Node tempNode = prevNode.children.firstWhere(
          (node) => node.char == prompt.substring(index, index + 1),
          orElse: () => none);
      print("temp: ${tempNode.toString()}");
      if (tempNode.char == none.char) {
        if (!reachLast) return [];
        break;
      } else {
        prevNode = tempNode;
        index++;
      }
    }

    print("First node : ${prevNode.char}");
    List<String> result = [];
    collect(prevNode, "", result);
    result.forEach((e) => print("$prompt${e.substring(1)}"));

    return possibleWords;
  }

  void collect(Node node, String text, List<String> results) {
    if (node.isEnd) {
      results.add(text + node.char);
      print(
          "adding ${text + node.char} and left child are ${node.children.map((e) => e.char)}");
      //git a string
    }
    for (var child in node.children) {
      collect(child, text + node.char, results);
    }
  }
}
