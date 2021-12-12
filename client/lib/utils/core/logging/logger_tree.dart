import 'package:fimber/fimber.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  filter: null,
  printer: PrettyPrinter(),
  output: null,
);

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
      logger.v(message, ex, stacktrace);
    } else if (level == 'D') {
      logger.d(message, ex, stacktrace);
    } else if (level == 'I') {
      logger.i(message, ex, stacktrace);
    } else if (level == 'W') {
      logger.w(message, ex, stacktrace);
    } else if (level == 'E') {
      logger.e(message, ex, stacktrace);
    }
  }
}
