import 'package:either_dart/src/either.dart';

import 'package:keeper/core/error.dart';
import 'package:keeper/features/write/data/write_storage.dart';

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
  Future<Either<AppError, int>> saveWord(String word) {
    // TODO: implement saveWord
    throw UnimplementedError();
  }
}
