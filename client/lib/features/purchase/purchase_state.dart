library purchase_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'purchase_state.g.dart';

abstract class PurchaseState
    implements Built<PurchaseState, PurchaseStateBuilder> {
  factory PurchaseState([void Function(PurchaseStateBuilder b) updates]) =
      _$PurchaseState;

  PurchaseState._();

  BuiltList<PurchaseDetails> get pastPurchases;
  BuiltList<ProductDetails> get productsForSale;

  bool get hasQuestsAccess;
  bool get isPurchasesAvailable;

  static PurchaseState initial() => PurchaseState((b) => b
    ..hasQuestsAccess = false
    ..isPurchasesAvailable = true
    ..productsForSale = ListBuilder());
}
