import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> loginEpic({@required UserService userService}) {
  final logoutEpic = epic((action$, store) {
    return action$
        .whereType<LogoutAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .logout()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final loginViaFacebookEpic = epic((action$, store) {
    return action$
        .whereType<LoginViaFacebookAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .loginViaFacebook(token: action.token)
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final loginViaGoogleEpic = epic((action$, store) {
    return action$
        .whereType<LoginViaGoogleAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .loginViaGoogle(
              accessToken: action.accessToken,
              idToken: action.idToken,
            )
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final loginViaAppleEpic = epic((action$, store) {
    return action$
        .whereType<LoginViaAppleAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .loginViaApple(
              accessToken: action.accessToken,
              idToken: action.idToken,
              firstName: action.firstName,
              lastName: action.lastName,
            )
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final sendUserPushTokenEpic = epic((action$, store) {
    return action$
        .whereType<SendDevicePushTokenAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => userService
            .sendUserPushToken(
              userId: action.userId,
              pushToken: action.pushToken,
            )
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final loadUserProfileEpic = epic((action$, store) {
    return action$
        .whereType<LoadCurrentUserProfileAsyncAction>()
        .where((action) => action.isStarted)
        .where((action) => store.state.login.currentUser?.id != null)
        .flatMap((action) => userService
            .loadProfile(store.state.login.currentUser.id)
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final updateCurrentQuestIndexEpic = epic((action$, store) {
    return action$
        .whereType<UpdateCurrentQuestIndexAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) {
      try {
        final updatedProfile = userService.updateCurrentQuestIndex(
          action.newQuestIndex,
        );

        return Stream.value(action.complete(updatedProfile));
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        return Stream.value(action.fail(error));
      }
    });
  });

  return combineEpics([
    logoutEpic,
    loginViaFacebookEpic,
    loginViaGoogleEpic,
    loginViaAppleEpic,
    sendUserPushTokenEpic,
    loadUserProfileEpic,
    updateCurrentQuestIndexEpic,
  ]);
}
