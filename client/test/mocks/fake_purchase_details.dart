import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/mockito.dart';

@immutable
class FakePurchaseDetails extends Fake implements PurchaseDetails {
  FakePurchaseDetails({
    @required String productId,
    @required String purchaseId,
    @required PurchaseStatus status,
    bool pendingComplete = false,
    PurchaseVerificationData verificationData,
  })  : _fakeProductId = productId,
        _fakePurchaseId = purchaseId,
        _fakeStatus = status,
        _fakePendingPurchase = pendingComplete,
        _fakeVerificationData = verificationData;

  final String _fakeProductId;
  final String _fakePurchaseId;
  final PurchaseStatus _fakeStatus;
  final bool _fakePendingPurchase;
  final PurchaseVerificationData _fakeVerificationData;

  @override
  String get productID => _fakeProductId;

  @override
  String get purchaseID => _fakePurchaseId;

  @override
  PurchaseStatus get status => _fakeStatus;

  @override
  bool get pendingCompletePurchase => _fakePendingPurchase;

  @override
  PurchaseVerificationData get verificationData => _fakeVerificationData;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        runtimeType == other.runtimeType &&
            other is FakePurchaseDetails &&
            productID == other.productID &&
            purchaseID == other.purchaseID &&
            status == other.status &&
            pendingCompletePurchase == other.pendingCompletePurchase;
  }

  @override
  int get hashCode =>
      '$productID - $purchaseID - $status - $pendingCompletePurchase'.hashCode;
}
