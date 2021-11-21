import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_details_request_model.freezed.dart';
part 'purchase_details_request_model.g.dart';

@freezed
class PurchaseDetailsRequestModel with _$PurchaseDetailsRequestModel {
  factory PurchaseDetailsRequestModel({
    required String productId,
    required String purchaseId,
  }) = _PurchaseDetailsRequestModel;

  factory PurchaseDetailsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseDetailsRequestModelFromJson(json);
}
