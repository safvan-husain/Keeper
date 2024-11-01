import 'package:either_dart/src/either.dart';

import 'package:keeper/core/error.dart';
import 'package:keeper/features/write/data/write_storage.dart';

import 'package:keeper/features/write/domain/entity/predicted_word.dart';

import '../domain/repository.dart';

class WriteRepositoryImpl implements WriteRepository {
  final storage = WriteStorage();

  @override
  Future<Either<AppError, PredictedWord>> predictWord(String prompt) {
    // TODO: implement predictWord
    throw UnimplementedError();
  }

  @override
  Future<Either<AppError, int>> saveWord(String word) {
    // TODO: implement saveWord
    throw UnimplementedError();
  }
}
