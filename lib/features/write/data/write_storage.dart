import 'package:keeper/features/write/domain/entity/predicted_word.dart';
import 'package:objectbox/objectbox.dart';
import '../../../core/app_storage.dart';
import '../../../objectbox.g.dart';
import '../domain/entity/chacter_node.dart';
import '../domain/entity/journal.dart';

class WriteStorage {
  final AppStorage storage;

  WriteStorage({required this.storage});

  Stream<List<Journal>> subscribe() {
    return storage.journalBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
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

    var query2 = storage.journalBox.query().build();

    var result2 = await query2.findAsync();
    print(result2);
  }

  void deleteALl() async {
    await storage.journalBox.removeAllAsync();
    await storage.characterBox.removeAllAsync();
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
      var code = await storage.saveWord(token);
      codeContent.add(code);
    }

    var journalId = storage.journalBox.put(
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
    query = storage.characterBox.query(condition).build();
    var result = await query.findAsync();

    for (var node in result) {
      node.usedPages.add(journalId);
      storage.characterBox.putAsync(node);
    }
    query.close();
  }

  List<String> predictWord(String prompt) => storage.predictWord(prompt);

  Future<String> decodeContent(Journal journal) async {
    var futureContent = journal.content.map((e) async {
      var query = storage.characterBox.query(Node_.id.equals(e)).build();
      var result = await query.findAsync();
      Node node = result.first;
      return node.getWord();
    }).toList();
    var content = await Future.wait(futureContent);
    return content.join(" ");
  }

  Future<void> _unMarkTokenUsedIn(Journal journal) async {
    for (var e in journal.content) {
      var query = storage.characterBox.query(Node_.id.equals(e)).build();
      var result = await query.findAsync();
      for (var e in result) {
        e.usedPages.removeWhere((k) => k == journal.id);
        await storage.characterBox.putAsync(e);
      }
    }
  }
}
