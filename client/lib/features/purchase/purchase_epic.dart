import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> purchaseEpic({@required PurchaseService purchaseService}) {
  final purchaseEpic = epic((action$, store) {
    return action$
        .whereType<StartListeningPurchasesAction>() //
        .flatMap((action) => purchaseService
            .listenPurchaseUpdates()
            .map((purchases) => OnPurchasesUpdatedAction(purchases)));
  });

  final isAvailableEpic = epic((action$, store) {
    return action$
        .whereType<IsPurchasesAvailableAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .isAvailable()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final queryProductsForSaleEpic = epic((action$, store) {
    return action$
        .whereType<QueryProductsForSaleAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .queryProductDetails(ids: action.ids)
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final queryPastPurchasesEpic = epic((action$, store) {
    return action$
        .whereType<QueryPastPurchasesAsyncAction>()
        .where((_) => store.state.login.currentUser != null)
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .queryPastPurchases(store.state.login.currentUser?.id)
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final onPastPurchasesRestored = epic((action$, store) {
    return action$ //
        .whereType<OnPastPurchasesRestoredAction>()
        .where((_) => store.state.login.currentUser != null)
        .flatMap((_) => purchaseService.pastPurchases
            .map((purchases) => OnPastPurchasesRestoredAction(purchases)));
  });

  final buyConsumableEpic = epic((action$, store) {
    return action$
        .whereType<BuyConsumableAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .buyConsumable(productDetails: action.product)
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final buyNonConsumableEpic = epic((action$, store) {
    return action$
        .whereType<BuyNonConsumableAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .buyNonConsumable(productDetails: action.product)
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final buyQuestsAccessEpic = epic((action$, store) {
    return action$
        .whereType<BuyQuestsAccessAsyncAction>()
        .where((_) => store.state.login.currentUser != null)
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .buyQuestsAcceess(store.state.login.currentUser.id)
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    purchaseEpic,
    isAvailableEpic,
    queryProductsForSaleEpic,
    queryPastPurchasesEpic,
    onPastPurchasesRestored,
    buyConsumableEpic,
    buyNonConsumableEpic,
    buyQuestsAccessEpic,
  ]);
}
