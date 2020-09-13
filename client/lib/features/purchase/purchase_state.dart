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

  RequestState get getPastPurchasesRequestState;
  RequestState get buyQuestsAccessRequestState;

  BuiltList<PurchaseDetails> get updatedPurchases;
  BuiltList<PurchaseDetails> get pastPurchases;

  bool get hasQuestsAccess;

  static PurchaseState initial() => PurchaseState((b) => b
    ..getPastPurchasesRequestState = RequestState.idle
    ..buyQuestsAccessRequestState = RequestState.idle
    ..hasQuestsAccess = false
    ..updatedPurchases = ListBuilder()
    ..pastPurchases = ListBuilder());
}
