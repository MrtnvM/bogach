import 'package:flutter/material.dart';

final appRouter = AppRouter();

class AppRouter {
  final navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context {
    return navigatorKey.currentState!.overlay!.context;
  }

  void startWith(Widget route) {
    navigatorKey.currentState!.pushAndRemoveUntil<Widget>(
      MaterialPageRoute(
        builder: (context) => route,
        settings: RouteSettings(
          name: route.runtimeType.toString(),
        ),
      ),
      (route) => false,
    );
  }

  Future<T?> goTo<T>(Widget route) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(
        builder: (context) => route,
        settings: RouteSettings(
          name: route.runtimeType.toString(),
        ),
      ),
    );
  }

  void goToRoot() {
    navigatorKey.currentState!.popUntil(
      (predicate) => predicate.isFirst,
    );
  }

  void goBackUntil(String name) {
    navigatorKey.currentState!.popUntil(
      (predicate) => predicate.settings.name == name,
    );
  }

  void goBack([dynamic value]) {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(value);
    }
  }
}
