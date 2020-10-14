import 'package:cash_flow/models/network/request/purchases/purchase_details_request_model.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_purchases_request_model.g.dart';

@JsonSerializable()
class UpdatePurchasesRequestModel {
  UpdatePurchasesRequestModel({
    @required this.userId,
    @required this.purchases,
  });

  factory UpdatePurchasesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatePurchasesRequestModelFromJson(json);

  final String userId;
  final List<PurchaseDetailsRequestModel> purchases;

  Map<String, dynamic> toJson() => _$UpdatePurchasesRequestModelToJson(this);
}
