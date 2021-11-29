import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/services/revenue_cat_purchase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class LoginViaAppleAction extends BaseAction {
  LoginViaAppleAction({
    required this.accessToken,
    required this.idToken,
    required this.firstName,
    required this.lastName,
  });

  final String accessToken;
  final String idToken;
  final String? firstName;
  final String? lastName;

  @override
  Future<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();
    final purchaseService = GetIt.I.get<RevenueCatPurchaseService>();

    final currentUser = await userService.loginViaApple(
      accessToken: accessToken,
      idToken: idToken,
      firstName: firstName,
      lastName: lastName,
    );
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
