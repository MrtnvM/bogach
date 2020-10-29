import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/profile/actions/on_current_profile_updated_action.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class StartListeningProfileUpdatesAction extends BaseAction {
  StartListeningProfileUpdatesAction(this.userId) : assert(userId != null);

  final String userId;

  @override
  FutureOr<AppState> reduce() {
    final userService = GetIt.I.get<UserService>();
    final action$ = GetIt.I.get<ReduxActionObserver>().onAction;

    userService
        .subscribeOnUser(userId)
        .takeUntil(action$
            .whereType<StopListeningProfileUpdatesAction>()
            .where((action) => action.userId == userId))
        .map<BaseAction>((profile) => OnCurrentProfileUpdatedAction(profile))
        // TODO check error handling
        .onErrorReturnWith(
            (error) => StartListeningProfileUpdatesAction(userId))
        .listen(dispatch);

    return null;
  }
}

class StopListeningProfileUpdatesAction extends BaseAction {
  StopListeningProfileUpdatesAction(this.userId) : assert(userId != null);

  final String userId;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      s.profile.currentUser = null;
    });
  }
}
