import 'package:either_dart/either.dart';

import '../../../core/error.dart';
import '../../write/domain/entity/chacter_node.dart';
import '../../write/domain/entity/journal.dart';

abstract class InsightRepository {
  Future<Either<AppError, List<Journal>>> getJournalsContainingWord({
    required String word,
  });

  Future<Either<AppError, List<String>>> predictWord(String prompt);

  Future<Either<AppError, Node>> getLastNode(String elementAt);
}
