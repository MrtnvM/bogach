import 'package:cash_flow/models/network/errors/email_has_been_taken_exception.dart';
import 'package:cash_flow/models/network/errors/invalid_credentials_exception.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

typedef HandleErrorCallback = Exception Function(String);

class ErrorHandler {
  ErrorHandler([this.handleErrorCallback]);

  final HandleErrorCallback handleErrorCallback;

  void handleError(dynamic error, dynamic stacktrace) {
    _recordError(error, stacktrace);

    if (error is PlatformException) {
      switch (error.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          throw NetworkConnectionException(null);

        case 'ERROR_USER_NOT_FOUND':
          throw const InvalidCredentialsException();

        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw const EmailHasBeenTakenException();
      }

      final exception = handleErrorCallback?.call(error.code);
      throw exception ?? error;
    }

    throw error;
  }

  void _recordError(error, stacktrace) {
    FirebaseCrashlytics.instance.recordError(error, stacktrace);
  }
}
