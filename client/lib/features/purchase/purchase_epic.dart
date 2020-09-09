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
            .takeUntil(action$.whereType<StopListeningPurchasesAction>())
            .map((purchases) => ListeningPurchasesSuccessAction(purchases))
            .onErrorReturnWith((e) => ListeningPurchasesSuccessAction(e)));
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
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .queryPastPurchases()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
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
        .where((action) => action.isStarted)
        .flatMap((action) => purchaseService
            .buyQuestsAcceess()
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    purchaseEpic,
    isAvailableEpic,
    queryProductsForSaleEpic,
    queryPastPurchasesEpic,
    buyConsumableEpic,
    buyNonConsumableEpic,
    buyQuestsAccessEpic,
  ]);
}
