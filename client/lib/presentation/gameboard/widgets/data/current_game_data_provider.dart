import 'package:flutter/material.dart';

class CurrentGameDataProvider extends InheritedWidget {
  const CurrentGameDataProvider({
    Key key,
    @required this.gameId,
    @required Widget child,
  }) : super(key: key, child: child);

  final String gameId;

  static CurrentGameDataProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CurrentGameDataProvider>();
    assert(result != null, 'No CurrentGameDataProvider found in context');
    return result;
  }

  @override
  bool updateShouldNotify(CurrentGameDataProvider oldWidget) {
    return oldWidget.gameId != gameId;
  }
}
