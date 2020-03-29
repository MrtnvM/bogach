import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'business_asset_response_model.g.dart';

@JsonSerializable()
class BusinessAssetResponseModel {
  const BusinessAssetResponseModel({
    this.cost,
    this.downPayment,
    this.name,
    this.type,
  });

  factory BusinessAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessAssetResponseModelFromJson(json);

  @JsonKey(name: 'cost')
  final int cost;
  @JsonKey(name: 'downPayment')
  final int downPayment;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;

  Map<String, dynamic> toJson() => _$BusinessAssetResponseModelToJson(this);
}
