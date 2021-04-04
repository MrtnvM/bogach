import 'package:fimber/fimber_base.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseReportingTree extends LogTree {
  FirebaseReportingTree({this.logLevels = defaultLevels});

  static const List<String> defaultLevels = ['V', 'D', 'I', 'W', 'E'];
  final List<String> logLevels;

  @override
  List<String> getLevels() => logLevels;

  @override
  void log(String level, String message,
      {String tag, dynamic ex, StackTrace stacktrace}) {
    final crashlytics = FirebaseCrashlytics.instance;
    crashlytics.log(message);

    if (ex != null) {
      crashlytics.recordError(ex, stacktrace);
    }
  }
}
