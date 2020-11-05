import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class LoginViaAppleAction extends BaseAction {
  LoginViaAppleAction({
    @required this.accessToken,
    @required this.idToken,
    @required this.firstName,
    @required this.lastName,
  })  : assert(accessToken != null),
        assert(idToken != null);

  final String accessToken;
  final String idToken;
  final String firstName;
  final String lastName;

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    final currentUser = await userService.loginViaApple(
      accessToken: accessToken,
      idToken: idToken,
      firstName: firstName,
      lastName: lastName,
    );

    return state.rebuild((s) {
      s.profile.currentUser = currentUser;
    });
  }

  @override
  void after() {
    super.after();

    final userId = state.profile.currentUser?.userId;
    if (userId != null) {
      dispatch(StartListeningProfileUpdatesAction(userId));
    }
  }
}
