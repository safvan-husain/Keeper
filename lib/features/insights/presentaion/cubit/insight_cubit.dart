import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:keeper/features/insights/domain/repository.dart';
import 'package:meta/meta.dart';

import '../../../view_entries/presentation/word_insight_screen.dart';
import '../../../write/domain/entity/journal.dart';

part 'insight_state.dart';

class InsightCubit extends Cubit<InsightState> {
  final InsightRepository repository;

  InsightCubit(this.repository) : super(InsightState.initial());

  void getPossibleWords(String word) async {
    var result = await repository.predictWord(word);

    result.fold((l) {}, (r) {
      emit(
        state.copyWith(
          availableWords: r.map((e) => "$word$e").toList(),
        ),
      );
    });
  }

  Future<void> _loadJournals(String word) async {
    var result = await repository.getJournalsContainingWord(word: word);

    result.fold((l) {}, (r) {
      emit(state.copyWith(journals: r));
    });
  }

  void showInsightFor(int index) async {
    String word = state.availableWords.elementAt(index);
    var result = await repository.getLastNode(word);

    await _loadJournals(word);
    result.fold(
      (l) {},
      (r) {
        Get.to(
          () => InsightScreen(
            journals: state.journals,
            word: word,
            node: r,
          ),
        );
      },
    );
  }
}
