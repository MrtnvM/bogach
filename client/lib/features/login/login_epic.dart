import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> loginEpic({@required UserService userService}) {
  final loginEpic = epic((action$, store) {
    return action$
        .whereType<LoginAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .login(email: action.email, password: action.password)
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final logoutEpic = epic((action$, store) {
    return action$
        .whereType<LogoutAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .logout()
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final loginViaFacebookEpic = epic((action$, store) {
    return action$
        .whereType<LoginViaFacebookAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .loginViaFacebook(token: action.token)
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final loginViaGoogleEpic = epic((action$, store) {
    return action$
        .whereType<LoginViaGoogleAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .loginViaGoogle(token: action.token, idToken: action.idToken)
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    loginEpic,
    logoutEpic,
    loginViaFacebookEpic,
    loginViaGoogleEpic,
  ]);
}
