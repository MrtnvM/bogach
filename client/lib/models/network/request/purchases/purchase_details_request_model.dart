import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_details_request_model.g.dart';

@JsonSerializable()
class PurchaseDetailsRequestModel {
  PurchaseDetailsRequestModel({
    @required this.productId,
    @required this.purchaseId,
    this.verificationData,
    this.source,
  });

  factory PurchaseDetailsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseDetailsRequestModelFromJson(json);

  final String productId;
  final String purchaseId;
  final String verificationData;
  final String source;

  Map<String, dynamic> toJson() => _$PurchaseDetailsRequestModelToJson(this);
}
