import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void configureErrorReporting() {
  Crashlytics.instance.enableInDevMode = false;

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
}
