import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:rxdart/transformers.dart';

typedef HandleErrorCallback = Exception Function(String);

class ErrorHandler<S> extends StreamTransformerBase<S, S> {
  ErrorHandler(this.handleErrorCallback);

  final HandleErrorCallback handleErrorCallback;

  @override
  Stream<S> bind(Stream<S> stream) {
    return stream.doOnError(_recordError).onErrorResume((error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_NETWORK_REQUEST_FAILED') {
          return Stream.error(NetworkConnectionException(null));
        }

        final exception = handleErrorCallback?.call(error.code);

        return Stream.error(exception ?? error);
      }

      return Stream.error(error);
    });
  }

  void _recordError(error, stacktrace) {
    Crashlytics.instance.recordError(error, stacktrace);
  }
}
