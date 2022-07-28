import 'package:flutter/material.dart';
import 'package:skoolfame/main.dart';

///
/// Exception model class
///
class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    final SnackBar snackBar = SnackBar(
        content: Text(_message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating);
    snackbarKey.currentState?.showSnackBar(snackBar);
    return "$_prefix $_message";
  }
}

/// throw exception when failed to communication with server
///
class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "Error During Communication:");
}

/// throw exception when called invalid request
///
class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

/// throw exception when pass unauthorised user token
///
class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
