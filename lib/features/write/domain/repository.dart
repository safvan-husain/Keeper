import 'package:either_dart/either.dart';
import 'package:keeper/features/write/domain/entity/predicted_word.dart';

import '../../../core/error.dart';
import 'entity/journal.dart';

abstract class WriteRepository {
  Future<Either<AppError, List<String>>> predictWord(String prompt);

  Future<Either<AppError, int>> saveJournal({
    required String content,
    required Journal journal,
  });

  Stream<List<Journal>> subscribe();

  Future<Either<AppError, String>> getJournalContent(Journal journal);
}
