import 'package:either_dart/src/either.dart';
import 'package:keeper/core/error.dart';
import 'package:keeper/features/insights/domain/repository.dart';
import 'package:keeper/features/write/domain/entity/journal.dart';

class InsightRepositoryImpl implements InsightRepository {
  @override
  Future<Either<AppError, List<Journal>>> getJournalsContainingWord(
      {required String word}) {
    // TODO: implement getJournalsContainingWord
    throw UnimplementedError();
  }

  @override
  Future<Either<AppError, List<String>>> predictWord(String prompt) {
    // TODO: implement predictWord
    throw UnimplementedError();
  }
}
