// ignore_for_file: prefer_typing_uninitialized_variables, unused_field

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_message $_prefix";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "Please, check your internet connection.");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Please, try later.");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Please, try later.");
}
