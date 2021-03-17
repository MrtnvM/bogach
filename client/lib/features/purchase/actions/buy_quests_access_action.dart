import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:get_it/get_it.dart';

class BuyQuestsAccessAction extends BaseAction {
  @override
  Operation get operationKey => Operation.buyQuestsAcceess;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  Future<AppState> reduce() async {
    final userId = state.profile.currentUser.id;

    final purchaseService = GetIt.I.get<PurchaseService>();
    await purchaseService.buyQuestsAccess(userId);

    return null;
  }
}
