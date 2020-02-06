import 'package:flutter/material.dart';

final AppRouter appRouter = AppRouter();

class AppRouter {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BuildContext get context {
    return navigatorKey.currentState.overlay.context;
  }

  void startWith(Widget route) {
    navigatorKey.currentState.pushAndRemoveUntil<Widget>(
      MaterialPageRoute(
        builder: (context) => route,
        settings: RouteSettings(
          name: route.runtimeType.toString(),
          isInitialRoute: true,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<Widget> goTo(Widget route) {
    return navigatorKey.currentState.push<Widget>(
      MaterialPageRoute(
          builder: (BuildContext context) => route,
          settings: RouteSettings(
            name: route.runtimeType.toString(),
            isInitialRoute: false,
          )),
    );
  }

  void goToRoot() {
    navigatorKey.currentState.popUntil((predicate) => predicate.isFirst);
  }

  void goBackUntil(String name) {
    navigatorKey.currentState.popUntil(
      (predicate) => predicate.settings.name == name,
    );
  }

  void goBack() {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.pop();
    }
  }
}
