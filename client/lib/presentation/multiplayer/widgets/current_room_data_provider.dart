import 'package:flutter/material.dart';

class CurrentRoomDataProvider extends InheritedWidget {
  const CurrentRoomDataProvider({
    Key? key,
    required this.roomId,
    required Widget child,
  }) : super(key: key, child: child);

  final String? roomId;

  static CurrentRoomDataProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CurrentRoomDataProvider>()!;
    return result;
  }

  @override
  bool updateShouldNotify(CurrentRoomDataProvider oldWidget) {
    return oldWidget.roomId != roomId;
  }
}
