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
    ),
  );
}

class _PurchaseActions {
  _PurchaseActions({
    @required this.buyQuestsAccess,
  });

  final Future<void> Function() buyQuestsAccess;
}
