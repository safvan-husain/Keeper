import 'package:either_dart/src/either.dart';
import 'package:keeper/core/error.dart';
import 'package:keeper/features/insights/data/insight_storage.dart';
import 'package:keeper/features/insights/domain/repository.dart';
import 'package:keeper/features/write/domain/entity/chacter_node.dart';
import 'package:keeper/features/write/domain/entity/journal.dart';

class InsightRepositoryImpl implements InsightRepository {
  final InsightStorage storage;

  InsightRepositoryImpl({required this.storage});

  @override
  Future<Either<AppError, List<Journal>>> getJournalsContainingWord(
      {required String word}) async {
    return Right(await storage.getJournalsContainingWord(word));
  }

  @override
  Future<Either<AppError, List<String>>> predictWord(String prompt) async {
    return Right(storage.getPrediction(prompt));
  }

  @override
  Future<Either<AppError, Node>> getLastNode(String word) async {
    return Right(await storage.getLastNode(word));
  }
}
