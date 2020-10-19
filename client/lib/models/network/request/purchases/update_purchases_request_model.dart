import 'package:cash_flow/models/network/request/purchases/purchase_details_request_model.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_purchases_request_model.freezed.dart';
part 'update_purchases_request_model.g.dart';

@freezed
abstract class UpdatePurchasesRequestModel with _$UpdatePurchasesRequestModel {
  factory UpdatePurchasesRequestModel({
    @required String userId,
    @required List<PurchaseDetailsRequestModel> purchases,
  }) = _UpdatePurchasesRequestModel;

  factory UpdatePurchasesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatePurchasesRequestModelFromJson(json);
}
