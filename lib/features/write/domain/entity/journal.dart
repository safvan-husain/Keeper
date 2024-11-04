import 'package:objectbox/objectbox.dart';

@Entity()
class Journal {
  @Id()
  int id;
  late String title;
  @Property(type: PropertyType.date)
  DateTime dateTime;
  List<int> content;

  Journal({
    this.id = 0,
    String? title,
    required this.dateTime,
    this.content = const [],
  }) {
    this.title = title ?? dateTime.toString().split(".").first;
  }
}
