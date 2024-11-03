import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:keeper/features/write/domain/entity/predicted_word.dart';
import 'package:keeper/features/write/domain/repository.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/journal.dart';

part 'write_state.dart';

class WriteCubit extends Cubit<WriteState> {
  final WriteRepository repository;

  WriteCubit(this.repository) : super(WriteState.initial());
  bool isEnterTapOnce = false;

  void acceptSuggestion(void Function(String content) updateController) {
    updateController(state.content);
  }

  void onAppendSomething(String currentLast, String input) {
    if (currentLast == " ") {
      clearSuggestionList();
    }
    updateSuggestion(input);
  }

  void clearSuggestionList() {
    print("clearing suggestion list");
    emit(state.copyWith(predictions: []));
  }

  void updateSuggestion(String input) async {
    print("updating suggestion");
    String? lastChar = input.split(" ").lastOrNull;
    if (lastChar == null) return;

    late List<String> prediction;

    if (state.predictions.isEmpty) {
      //generate
      var result = await repository.predictWord(lastChar);
      prediction = result.fold<List<String>>(
        (e) => ["error"],
        (r) => r,
      );
    } else {
      //when prediction cache available, curate from it
      prediction = state.predictions
          .where(
            (e) => e.startsWith(lastChar.characters.last),
          )
          .toList()
          .map((e) => e.substring(1))
          .toList();
    }
    //updating content
    emit(state.copyWith(
      predictions: prediction,
      content: input + (prediction.firstOrNull ?? ""),
    ));
  }

  void onBackSpace(String input) {
    clearSuggestionList();
    updateSuggestion(input);
  }

  void onEnter({required void Function() onAccept}) {
    if (isEnterTapOnce) {
      onAccept();
      isEnterTapOnce = false;
    }
  }

  void savePage(String content) async {
    List<String> tokens = content.split(" ");
    Journal codeContent = Journal(
      title: "Firs one",
      dateTime: DateTime.now(),
    );
    for (var token in tokens) {
      //save
      var code = await saveWord(token);
      if (code != null) {
        codeContent.addToken(code);
      }
    }

    //after savinng the page, update in word, that it beigng used here for insight.
  }

  Future<int?> saveWord(String word) async {
    var result = await repository.saveWord(word);
    return result.fold<int?>((l) => null, (r) => r);
  }

  void _addNewLine() {}
}
