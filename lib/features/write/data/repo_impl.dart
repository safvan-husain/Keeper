import 'package:either_dart/src/either.dart';

import 'package:keeper/core/error.dart';
import 'package:keeper/features/write/data/write_storage.dart';
import 'package:keeper/features/write/domain/entity/journal.dart';

import 'package:keeper/features/write/domain/entity/predicted_word.dart';

import '../domain/repository.dart';

class WriteRepositoryImpl implements WriteRepository {
  final WriteStorage storage;

  WriteRepositoryImpl(this.storage);

  @override
  Future<Either<AppError, List<String>>> predictWord(String prompt) async {
    return Right<AppError, List<String>>(storage.predictWord(prompt) ?? []);
  }

  @override
  Future<Either<AppError, int>> saveJournal(
      {required String content, required Journal journal}) async {
    try {
      var result =
          await storage.saveJournal(content: content, journal: journal);
      return Right(result);
    } catch (e) {
      return Left(AppError(code: ErrorCode.internalError));
    }
  }

  @override
  Stream<List<Journal>> subscribe() {
    return storage.subscribe();
  }

  @override
  Future<Either<AppError, String>> getJournalContent(Journal journal) async {
    return Right(await storage.decodeContent(journal));
  }
}
