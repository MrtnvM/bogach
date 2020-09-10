import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/features/purchase/purchase_state.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

final purchaseReducer = Reducer<PurchaseState>()
  ..on<LogoutAsyncAction>((state, action) => PurchaseState.initial())
  ..on<StartListeningPurchasesAction>(
    (state, action) => state.rebuild(
        (s) => s..listenPurchasesRequestState = RequestState.inProgress),
  )
  ..on<ListeningPurchasesSuccessAction>(
    (state, action) => state.rebuild(
      (s) {
        final boughtQuestsAccess = action.purchases.any(
          (p) =>
              p.productID == questsAccessProductId &&
              p.status == PurchaseStatus.purchased,
        );

        s
          ..listenPurchasesRequestState = RequestState.success
          ..updatedPurchases = action.purchases.toBuilder()
          ..hasQuestsAccess = s.hasQuestsAccess || boughtQuestsAccess;
      },
    ),
  )
  ..on<ListeningPurchasesErrorAction>(
    (state, action) => state
        .rebuild((s) => s..listenPurchasesRequestState = RequestState.error),
  )
  ..on<StopListeningPurchasesAction>(
    (state, action) => state
        .rebuild((s) => s..listenPurchasesRequestState = RequestState.idle),
  )
  ..on<QueryPastPurchasesAsyncAction>(
    (state, action) => state.rebuild((s) {
      s..getPastPurchasesRequestState = RequestState.idle;

      action
        ..onSuccess((purchases) {
          final boughtQuestsAccess = purchases.any(
            (p) =>
                p.productID == questsAccessProductId &&
                p.status == PurchaseStatus.purchased,
          );

          s
            ..pastPurchases = purchases.toBuilder()
            ..hasQuestsAccess = s.hasQuestsAccess || boughtQuestsAccess;
        });
    }),
  )
  ..on<BuyQuestsAccessAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.buyQuestsAccessRequestState = action.requestState;
    }),
  );
