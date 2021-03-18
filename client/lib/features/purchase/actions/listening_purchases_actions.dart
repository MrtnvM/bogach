import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/purchase/actions/query_past_purchases_action.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class StartListeningPurchasesAction extends BaseAction {
  StartListeningPurchasesAction();

  @override
  AppState reduce() {
    final purchaseService = GetIt.I.get<PurchaseService>();
    final action$ = GetIt.I.get<ReduxActionObserver>().onAction;

    purchaseService.startListeningPurchaseUpdates();

    purchaseService.pastPurchases
        .map((purchases) => OnPastPurchasesRestoredAction(purchases))
        .takeUntil(action$.whereType<StopListeningPurchasesAction>())
        .listen(dispatch);

    return null;
  }
}

class StopListeningPurchasesAction extends BaseAction {
  @override
  AppState reduce() {
    return null;
  }
}
