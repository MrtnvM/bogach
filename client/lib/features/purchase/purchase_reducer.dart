import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/features/purchase/purchase_state.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:built_collection/built_collection.dart';

final purchaseReducer = Reducer<PurchaseState>()
  ..on<LogoutAsyncAction>((state, action) => PurchaseState.initial())
  ..on<OnPurchasesUpdatedAction>(
    (state, action) => state.rebuild(
      (s) {
        final boughtQuestsAccess = action.purchases.any(
          (p) =>
              p.productID == questsAccessProductId &&
              p.status == PurchaseStatus.purchased,
        );

        s
          ..updatedPurchases = action.purchases.toBuiltList().toBuilder()
          ..hasQuestsAccess = s.hasQuestsAccess || boughtQuestsAccess;
      },
    ),
  )
  ..on<QueryPastPurchasesAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.getPastPurchasesRequestState = action.requestState;
    }),
  )
  ..on<OnPastPurchasesRestoredAction>(
    (state, action) => state.rebuild((s) {
      final purchases = action.pastPurchases;
      final boughtQuestsAccess = purchases.any(
        (p) =>
            p.productID == questsAccessProductId &&
            p.status == PurchaseStatus.purchased,
      );

      s
        ..pastPurchases = purchases.toBuiltList().toBuilder()
        ..hasQuestsAccess = s.hasQuestsAccess || boughtQuestsAccess;
    }),
  )
  ..on<BuyQuestsAccessAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.buyQuestsAccessRequestState = action.requestState;
    }),
  )
  ..on<LoadCurrentUserProfileAsyncAction>(
    (state, action) => state.rebuild((s) {
      action.onSuccess((userProfile) {
        final boughtQuestsAccess = userProfile?.boughtQuestsAccess == true;
        s.hasQuestsAccess = s.hasQuestsAccess || boughtQuestsAccess;
      });
    }),
  )
  ..on<SetCurrentUserAction>(
    (state, action) => state.rebuild((s) {
      final boughtQuestsAccess = action.user?.boughtQuestsAccess == true;
      s.hasQuestsAccess = s.hasQuestsAccess || boughtQuestsAccess;
    }),
  );
