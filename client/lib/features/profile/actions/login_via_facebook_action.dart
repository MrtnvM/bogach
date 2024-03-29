import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/services/revenue_cat_purchase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class LoginViaFacebookAction extends BaseAction {
  LoginViaFacebookAction({required this.token});

  final String token;

  @override
  Operation get operationKey => Operation.loginViaFacebook;

  @override
  Future<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();
    final purchaseService = GetIt.I.get<RevenueCatPurchaseService>();

    final currentUser = await userService.loginViaFacebook(token: token);
    await purchaseService.login(currentUser.userId);

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
