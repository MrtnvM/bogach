import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:fimber/fimber_base.dart';

class LoggerTree extends LogTree {
  LoggerTree({this.logLevels = defaultLevels});

  static const List<String> defaultLevels = ['V', 'D', 'I', 'W', 'E'];
  final List<String> logLevels;

  @override
  List<String> getLevels() => logLevels;

  @override
  void log(String level, String message,
      {String tag, dynamic ex, StackTrace stacktrace}) {
    Logger.e(message, ex, stacktrace);
  }
}
