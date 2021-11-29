import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:cash_flow/services/revenue_cat_purchase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class LogoutAction extends BaseAction {
  LogoutAction();

  @override
  Future<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();
    final usersAddToFriendsStorage = GetIt.I.get<UsersAddToFriendsStorage>();
    final purchaseService = GetIt.I.get<RevenueCatPurchaseService>();

    await userService.logout();
    await usersAddToFriendsStorage.clear();
    await purchaseService.logout();

    return state.rebuild((s) {
      s = AppState.initial().toBuilder();
    });
  }
}
