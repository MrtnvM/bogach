import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/features/profile/actions/set_current_user_action.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class LoginViaFacebookAction extends BaseAction {
  LoginViaFacebookAction({@required this.token}) : assert(token != null);

  final String token;

  @override
  Operation get operationKey => Operation.loginViaFacebook;

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    final currentUser = await userService.loginViaFacebook(token: token);
    dispatch(SetCurrentUserAction(currentUser));

    return null;
  }
}
