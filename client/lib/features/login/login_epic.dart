import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> loginEpic({@required UserService userService}) {
  final Epic<AppState> loginEpic = (action$, store) {
    return Observable(action$)
        .whereType<LoginAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .login()
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  };

  final Epic<AppState> logoutEpic = (action$, store) {
    return Observable(action$)
        .whereType<LogoutAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .logout()
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  };

  return combineEpics([
    loginEpic,
    logoutEpic,
  ]);
}
