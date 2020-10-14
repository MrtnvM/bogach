import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/mockito.dart';

class FakePurchaseDetails extends Fake implements PurchaseDetails {
  FakePurchaseDetails({
    @required String productId,
    @required String purchaseId,
    @required PurchaseStatus status,
    bool pendingComplete = false,
  })  : _fakeProductId = productId,
        _fakePurchaseId = purchaseId,
        _fakeStatus = status,
        _fakePendingPurchase = pendingComplete;

  final String _fakeProductId;
  final String _fakePurchaseId;
  final PurchaseStatus _fakeStatus;
  final bool _fakePendingPurchase;

  @override
  String get productID => _fakeProductId;

  @override
  String get purchaseID => _fakePurchaseId;

  @override
  PurchaseStatus get status => _fakeStatus;

  @override
  bool get pendingCompletePurchase => _fakePendingPurchase;
}
