import 'package:objectbox/objectbox.dart';

@Entity()
class Journal {
  @Id()
  int id;
  String? title;
  @Property(type: PropertyType.date)
  DateTime dateTime;
  List<int> content;

  Journal({
    this.id = 0,
    this.title,
    required this.dateTime,
    this.content = const [],
  });

  void addToken(int i) {
    content.add(i);
  }
}
