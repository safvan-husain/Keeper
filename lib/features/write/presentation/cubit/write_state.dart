part of 'write_cubit.dart';

enum InstanceType { error, sucess }

class WriteState {
  final InstanceType type;
  final String content;
  final List<String> predictions;
  final String? title;

  WriteState(
      {required this.type,
      required this.content,
      required this.predictions,
      this.title});

  factory WriteState.initial() {
    return WriteState(
      type: InstanceType.sucess,
      content: "",
      predictions: [],
    );
  }

  WriteState copyWith(
      {InstanceType? type,
      List<String>? predictions,
      String? title,
      String? content}) {
    return WriteState(
        type: type ?? this.type,
        content: content ?? this.content,
        predictions: predictions ?? this.predictions,
        title: title ?? this.title);
  }
}
