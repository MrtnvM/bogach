import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:get_it/get_it.dart';

class BuyQuestsAccessAction extends BaseAction {
  @override
  FutureOr<AppState> reduce() async {
    final userId = state.profile.currentUser?.id;

    if (userId == null) {
      return null;
    }

    final purchaseService = GetIt.I.get<PurchaseService>();

    await performRequest(
      purchaseService.buyQuestsAcceess(userId),
      NetworkRequest.buyQuestsAcceess,
    );

    return null;
  }
}
