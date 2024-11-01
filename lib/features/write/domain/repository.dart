import 'package:either_dart/either.dart';
import 'package:keeper/features/write/domain/entity/predicted_word.dart';

import '../../../core/error.dart';

abstract class WriteRepository {
  Future<Either<AppError, PredictedWord>> predictWord(String prompt);

  Future<Either<AppError, int>> saveWord(String word);
}
