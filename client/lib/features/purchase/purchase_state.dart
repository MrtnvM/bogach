library purchase_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'purchase_state.g.dart';

abstract class PurchaseState
    implements Built<PurchaseState, PurchaseStateBuilder> {
  factory PurchaseState([void Function(PurchaseStateBuilder b) updates]) =
      _$PurchaseState;

  PurchaseState._();

  RequestState get listenPurchasesRequestState;

  RequestState get getPastPurchasesRequestState;

  BuiltList<PurchaseDetails> get updatedPurchases;
  
  BuiltList<PurchaseDetails> get pastPurchases;

  static PurchaseState initial() => PurchaseState((b) => b
    ..listenPurchasesRequestState = RequestState.idle
    ..getPastPurchasesRequestState = RequestState.idle
    ..updatedPurchases = ListBuilder()
    ..pastPurchases = ListBuilder());
}
