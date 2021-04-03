import 'package:fimber/fimber_base.dart';
import 'package:flutter/foundation.dart';

void configureErrorReporting() {
  //FlutterError.onError = (FirebaseCrashlytics.instance.recordFlutterError;)

  FlutterError.onError = (FlutterErrorDetails flutterErrorDetails) {
    final reason = flutterErrorDetails.context;
    Fimber.e(
      reason.toString(),
      ex: flutterErrorDetails.exception,
      stacktrace: flutterErrorDetails.stack,
    );
  };
}
