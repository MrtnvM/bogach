import 'package:cash_flow/app/app_state.dart';
import 'package:redux/redux.dart';

class LogMiddleware implements MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    print(action);
    next(action);
  }
}
