import 'package:objectbox/objectbox.dart';

@Entity()
class Node {
  @Id()
  int id;
  String char;
  bool isEnd;
  ToMany<Node> children = ToMany<Node>();
  ToOne<Node> parent = ToOne<Node>();
  List<int> usedPages;

  Node(
      {this.id = 0,
      this.isEnd = false,
      required this.char,
      this.usedPages = const []});

  @override
  String toString() {
    return "$char -> ${children.isNotEmpty ? children.map((e) => e.toString).toList() : "no child"}";
  }

  String getWord() {
    if (parent.target == null) return "";

    return "${parent.target!.getWord()}$char";
  }
}
