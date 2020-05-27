import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_actions.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:flutter/foundation.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> multiplayerEpic({@required UserService userService}) {
  final queryUsersEpic = epic((action$, store) {
    return action$
        .whereType<QueryUserProfilesAsyncAction>()
        .where((action) => action.isStarted)
        .switchMap((action) => userService
            .searchUsers(action.query)
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    queryUsersEpic,
  ]);
}
