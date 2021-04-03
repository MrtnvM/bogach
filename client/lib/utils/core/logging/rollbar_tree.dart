import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rollbar/flutter_rollbar.dart';

class RollbarTree extends LogTree {
  RollbarTree({
    @required this.environmentName,
    this.logLevels = defaultLevels,
  }) {
    Rollbar()
      ..accessToken = 'f37216d51fe449f19afad8eff9d8b519'
      ..environment = environmentName;
  }

  static const List<String> defaultLevels = ['V', 'D', 'I', 'W', 'E'];
  final List<String> logLevels;
  final String environmentName;

  @override
  List<String> getLevels() => logLevels;

  @override
  void log(String level, String message,
      {String tag, dynamic ex, StackTrace stacktrace}) {
    var rollbarMessage = message;
    var level = RollbarLogLevel.INFO;
    var telemetryType = RollbarTelemetryType.LOG;

    if (ex != null) {
      rollbarMessage += ' ${ex.message}';
      rollbarMessage += ';\n exception: $ex';
      level = RollbarLogLevel.ERROR;
      telemetryType = RollbarTelemetryType.ERROR;
    }

    if (stacktrace != StackTrace.empty) {
      rollbarMessage += '; stacktrace: $stacktrace';
      level = RollbarLogLevel.ERROR;
      telemetryType = RollbarTelemetryType.ERROR;
    }

    Rollbar().addTelemetry(
      RollbarTelemetry(
        level: level,
        type: telemetryType,
        message: rollbarMessage,
      ),
    );

    Rollbar().publishReport(message: message);
  }
}
