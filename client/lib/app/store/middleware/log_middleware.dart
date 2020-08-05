import 'package:cash_flow/app/app_state.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:redux/redux.dart';

class LogMiddleware implements MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    print(action);

    if (action is AsyncAction) {
      if (action.isSucceed) {
        print('Success model:');
        print(action.successModel);
      } else if (action.isFailed) {
        print('Error model: \n');
        print(action.errorModel);
      }
    }

    next(action);
  }
}
