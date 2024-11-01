import 'package:bloc/bloc.dart';
import 'package:keeper/features/write/domain/entity/predicted_word.dart';
import 'package:keeper/features/write/domain/repository.dart';
import 'package:meta/meta.dart';

part 'write_state.dart';

class WriteCubit extends Cubit<WriteState> {
  final WriteRepository repository;

  WriteCubit(this.repository) : super(WriteState.initial());

  void appendNewChar(String char) {
    emit(state.copyWith(input: char));
  }

  void appendToken() {
    emit(
      state.copyWith(
        content: state.content + " " + state.input,
        input: "",
      ),
    );
  }

  void savePage() {}

  void saveWord() {
    repository.saveWord("");
  }

  void autoSuggestWord() {
    repository.predictWord("");
  }

  void _addNewLine() {}
}
