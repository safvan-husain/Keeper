import 'package:get/get_core/src/get_interface.dart';
import 'package:keeper/core/app_storage.dart';

import '../../../objectbox.g.dart';
import '../../write/domain/entity/chacter_node.dart';
import '../../write/domain/entity/journal.dart';

class InsightStorage {
  final AppStorage storage;

  const InsightStorage({required this.storage});

  Future<List<Journal>> getJournalsContainingWord(String word) async {
    int id = await storage.saveWord(word);
    var query = storage.characterBox.query(Node_.id.equals(id)).build();
    var node = await query.findAsync();
    Condition<Journal>? journalCondition;
    for (var journalId in node.first.usedPages) {
      journalCondition = journalCondition?.or(Journal_.id.equals(journalId)) ??
          Journal_.id.equals(journalId);
    }

    var journalQuery = storage.journalBox.query(journalCondition).build();
    return await journalQuery.findAsync();
  }

  List<String> getPrediction(String prompt) => storage.predictWord(prompt);

  Future<Node> getLastNode(String word) async {
    var query =
        storage.characterBox.query(Node_.char.equals(storage.rootChar)).build();
    var result = await query.findAsync();

    var node = result.first;

    var index = 0;
    var characters = word.split("").toList();

    bool isComplete = false;

    while (index < characters.length && node.children.isNotEmpty) {
      for (var child in node.children) {
        if (child.char == characters[index]) {
          node = child;
          print("found node for ${child.char}");
          index++;
          break;
        }
      }
    }

    return node;
  }
}
