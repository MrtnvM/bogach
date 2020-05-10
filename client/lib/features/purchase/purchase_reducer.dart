import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/features/purchase/purchase_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final purchaseReducer = Reducer<PurchaseState>()
  ..on<StartListeningPurchasesAction>(
    (state, action) => state.rebuild(
        (s) => s..listenPurchasesRequestState = RequestState.inProgress),
  )
  ..on<ListeningPurchasesSuccessAction>(
    (state, action) => state
        .rebuild((s) => s..listenPurchasesRequestState = RequestState.success),
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
        ..onSuccess((purchases) => s..pastPurchases = purchases.toBuilder());
    }),
  );
