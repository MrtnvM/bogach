import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

_PurchaseActions usePurchaseActions() {
  final actionRunner = useActionRunner();

  return useMemoized(
    () => _PurchaseActions(
      buyQuestsAccess: () {
        return actionRunner.runAsyncAction(BuyQuestsAccessAsyncAction());
      },
      restorePurchases: () {
        return actionRunner.runAsyncAction(QueryPastPurchasesAsyncAction());
      },
    ),
  );
}

class _PurchaseActions {
  _PurchaseActions({
    @required this.buyQuestsAccess,
    @required this.restorePurchases,
  });

  final Future<void> Function() buyQuestsAccess;
  final Future<void> Function() restorePurchases;
}
