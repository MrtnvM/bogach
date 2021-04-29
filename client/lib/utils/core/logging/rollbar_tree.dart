import 'package:fimber/fimber.dart';

class RollbarTree extends LogTree {
  RollbarTree({
    required this.environmentName,
    this.logLevels = defaultLevels,
  });

  static const List<String> defaultLevels = ['V', 'D', 'I', 'W', 'E'];
  final List<String> logLevels;
  final String environmentName;

  @override
  List<String> getLevels() => logLevels;

  @override
  void log(String level, String message,
      {String? tag, dynamic ex, StackTrace? stacktrace}) {
  }
}
