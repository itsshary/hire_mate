class AppExceptions implements Exception {
  final _perfix;
  final _message;
  AppExceptions([this._message, this._perfix]);

  String toString() {
    return "$_message,$_message";
  }
}

class FetchDataExceptions extends AppExceptions {
  FetchDataExceptions([String? message])
      : super(message, "Error During Communication");
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, "Invalid Request");
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message])
      : super(message, "Unauthorized Request");
}

class InvalidinputException extends AppExceptions {
  InvalidinputException([String? message]) : super(message, "Invalid Input");
}
