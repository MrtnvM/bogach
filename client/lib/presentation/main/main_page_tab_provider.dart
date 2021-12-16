import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum MainPageTab { games, recommendations, account }

MainPageTab useCurrentMainPageTab() {
  final context = useContext();
  final tab = MainPageTabProvider.of(context).currentTab;
  return tab;
}

class MainPageTabProvider extends InheritedWidget {
  const MainPageTabProvider({
    Key? key,
    required this.currentTab,
    required Widget child,
  }) : super(key: key, child: child);

  final MainPageTab currentTab;

  static MainPageTabProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<MainPageTabProvider>()!;
    return result;
  }

  @override
  bool updateShouldNotify(MainPageTabProvider oldWidget) {
    return oldWidget.currentTab != currentTab;
  }
}
