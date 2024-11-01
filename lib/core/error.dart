enum ErrorCode { notFound, internalError, unAuthorized }

class AppError {
  final ErrorCode code;
  late final String _message;

  String get message => _message;

  AppError({required this.code, String? message}) {
    if (message == null) {
      _message = switch (code) { ErrorCode.notFound => "Not Found", _ => "" };
    } else {
      _message = message;
    }
  }
}
