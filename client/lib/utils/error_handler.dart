import 'package:cash_flow/models/network/core/response_model.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/models/network/errors/email_has_been_taken_exception.dart';
import 'package:cash_flow/models/network/errors/invalid_credentials_exception.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

T recordError<T>(dynamic error, [dynamic stacktrace]) {
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
  }

  throw error;
}

String _getErrorMessage(dynamic error) {
  const prefix = 'network request error:';

  if (error is RequestErrorException || error is NetworkConnectionException) {
    final dioError = error.error;
    final message = dioError.message;
    final uri = dioError.request.uri;

    return '$prefix; message: $message; url: $uri';
  } else if (error is ResponseErrorModel) {
    final response = error.response;
    final message = response.statusMessage;
    final uri = response.realUri.query;
    return '$prefix; status: $message; url: $uri';
  } else {
    return '$prefix $error';
  }
}

void _recordError(dynamic error, dynamic stacktrace) {
  if (error is NetworkConnectionException ||
      error is InvalidCredentialsException ||
      error is EmailHasBeenTakenException ||
      error is PurchaseCanceledException) {
    return;
  }

  final message = _getErrorMessage(error);

  Fimber.e(
    message,
    ex: error,
    stacktrace: stacktrace,
  );
}
