import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/profile/actions/set_current_user_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class LoginViaGoogleAction extends BaseAction {
  LoginViaGoogleAction({
    @required this.accessToken,
    @required this.idToken,
  })  : assert(accessToken != null),
        assert(idToken != null);

  final String accessToken;
  final String idToken;

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    final currentUser = await performRequest(
      userService.loginViaGoogle(
        accessToken: accessToken,
        idToken: idToken,
      ),
      NetworkRequest.loginViaGoogle,
    );

    dispatch(SetCurrentUserAction(currentUser));

    return null;
  }
}
