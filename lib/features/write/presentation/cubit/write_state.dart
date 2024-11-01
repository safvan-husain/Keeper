part of 'write_cubit.dart';

enum InstanceType { error, sucess }

class WriteState {
  final InstanceType type;
  final String content;
  final String input;
  final List<PredictedWord> predictions;

  WriteState({
    required this.type,
    required this.content,
    required this.input,
    required this.predictions,
  });

  factory WriteState.initial() {
    return WriteState(
      type: InstanceType.sucess,
      content: "",
      input: "",
      predictions: [],
    );
  }

  WriteState copyWith(
      {InstanceType? type,
      String? input,
      List<PredictedWord>? predictions,
      String? content}) {
    return WriteState(
      type: type ?? this.type,
      input: input ?? this.input,
      content: content ?? this.content,
      predictions: predictions ?? this.predictions,
    );
  }
}
