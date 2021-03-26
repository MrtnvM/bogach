import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void configureErrorReporting() {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}
