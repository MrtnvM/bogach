import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/registration/registration_actions.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> registrationEpic({@required UserService userService}) {
  final Epic<AppState> registrationEpic = (action$, store) {
    return Observable(action$)
        .whereType<RegisterAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .register(model: action.model)
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  };

  return combineEpics([
    registrationEpic,
  ]);
}
