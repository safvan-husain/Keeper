import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:keeper/features/view_entries/presentation/list_journal_screen.dart';
import 'package:keeper/features/write/domain/repository.dart';
import 'package:keeper/features/write/presentation/widgets/modify_title_overlay.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/journal.dart';

part 'write_state.dart';

class WriteCubit extends Cubit<WriteState> {
  final WriteRepository repository;

  WriteCubit(this.repository) : super(WriteState.initial());

  late void Function(String content) textControllerUpdater;

  void init({
    required void Function(String content) textUpdater,
    required Journal journal,
  }) {
    textControllerUpdater = textUpdater;
    _loadContent(journal);
    emit(state.copyWith(title: journal.title));
  }

  void _loadContent(Journal journal) async {
    var result = await repository.getJournalContent(journal);
    String content = result.fold((l) => "Error . Exception", (r) => r);
    textControllerUpdater(content);
  }

  void acceptSuggestion() {
    textControllerUpdater(state.content);
  }

  void onAppendSomething(String currentLast, String input) {
    if (currentLast == " ") {
      clearSuggestionList();
    }
    updateSuggestion(input);
  }

  void clearSuggestionList() {
    emit(state.copyWith(predictions: []));
  }

  void updateSuggestion(String input) async {
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

  void savePage(String content, Journal journal) async {
    var result = await repository.saveJournal(
      content: content,
      journal: journal..title = state.title ?? journal.title,
    );
  }

  void showAllJournals() {
    emit(state.copyWith(content: ""));
    g.Get.to(
      () => const ListJournalScreen(),
      transition: g.Transition.fade,
    );
  }

  void showOverlay() {
    Get.dialog(
      ModifyTitleOverlay(
        title: state.title ?? "",
      ),
      barrierColor: Colors.black26,
    );
  }

  void changeTitle(String newTitle) {
    emit(state.copyWith(title: newTitle));
  }
}
