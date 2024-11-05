part of 'insight_cubit.dart';

class InsightState {
  final String searchTerm;
  final List<String> availableWords;
  final List<Journal> journals;

  InsightState({
    required this.searchTerm,
    required this.availableWords,
    required this.journals,
  });

  InsightState copyWith({
    List<String>? availableWords,
    List<Journal>? journals,
    String? searchTerm,
  }) {
    return InsightState(
      journals: journals ?? this.journals,
      searchTerm: searchTerm ?? this.searchTerm,
      availableWords: availableWords ?? this.availableWords,
    );
  }

  factory InsightState.initial() {
    return InsightState(
      searchTerm: "",
      availableWords: [],
      journals: [],
    );
  }
}
