import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class LogoutAction extends BaseAction {
  LogoutAction();

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    await userService.logout();

    return state.rebuild((s) {
      s = AppState.initial().toBuilder();
    });
  }
}
