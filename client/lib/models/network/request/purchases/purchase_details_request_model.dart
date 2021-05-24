import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'purchase_details_request_model.freezed.dart';
part 'purchase_details_request_model.g.dart';

@freezed
class PurchaseDetailsRequestModel with _$PurchaseDetailsRequestModel {
  factory PurchaseDetailsRequestModel({
    required String productId,
    required String purchaseId,
    String? verificationData,
    String? source,
  }) = _PurchaseDetailsRequestModel;

  factory PurchaseDetailsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseDetailsRequestModelFromJson(json);

  static PurchaseDetailsRequestModel fromPurchase(PurchaseDetails purchase) {
    return PurchaseDetailsRequestModel(
      productId: purchase.productID,
      purchaseId: purchase.purchaseID!,
      verificationData: purchase.verificationData.serverVerificationData,
      source: purchase.verificationData.source.toString(),
    );
  }
}
