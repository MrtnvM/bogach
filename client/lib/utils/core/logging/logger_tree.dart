import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:fimber/fimber.dart';

class LoggerTree extends LogTree {
  LoggerTree({this.logLevels = defaultLevels});

  static const List<String> defaultLevels = ['V', 'D', 'I', 'W', 'E'];
  final List<String> logLevels;

  @override
  List<String> getLevels() => logLevels;

  @override
  void log(String level, String message,
      {String? tag, dynamic ex, StackTrace? stacktrace}) {
    if (level == 'V') {
      Logger.v(message, ex, stacktrace);
    } else if (level == 'D') {
      Logger.d(message, ex, stacktrace);
    } else if (level == 'I') {
      Logger.i(message, ex, stacktrace);
    } else if (level == 'W') {
      Logger.w(message, ex, stacktrace);
    } else if (level == 'E') {
      Logger.e(message, ex, stacktrace);
    }
  }
}
