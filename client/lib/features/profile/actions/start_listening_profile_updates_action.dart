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
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();
    final action$ = GetIt.I.get<ReduxActionObserver>().onAction;

    /// Requesting user profile through the server request will
    /// auto-migrate it to the newer version
    try {
      final userProfile = await userService.loadUserFromServer(userId);
      dispatch(OnCurrentProfileUpdatedAction(userProfile));
      userService.saveUserProfileInCache(userProfile);
    } catch (err) {
      _executeDelayed(() {
        dispatch(StartListeningProfileUpdatesAction(userId));
      });
      return null;
    }

    userService
        .subscribeOnUser(userId)
        .takeUntil(action$.whereType<StopListeningProfileUpdatesAction>())
        .map<BaseAction>((profile) => OnCurrentProfileUpdatedAction(profile))
        // TODO(Maxim): check error handling
        .onErrorResumeNext(
          Stream.value(StartListeningProfileUpdatesAction(userId))
              .delay(const Duration(milliseconds: 500)),
        )
        .listen(dispatch);

    return null;
  }

  void _executeDelayed(Function lambda) {
    Future.delayed(const Duration(milliseconds: 500)).then((_) => lambda());
  }
}

class StopListeningProfileUpdatesAction extends BaseAction {
  StopListeningProfileUpdatesAction();

  @override
  FutureOr<AppState> reduce() {
    return null;
  }
}
