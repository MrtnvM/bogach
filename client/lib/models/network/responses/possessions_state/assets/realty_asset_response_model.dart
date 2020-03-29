import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'realty_asset_response_model.g.dart';

@JsonSerializable()
class RealtyAssetResponseModel {
  const RealtyAssetResponseModel({
    this.cost,
    this.downPayment,
    this.name,
    this.type,
  });

  factory RealtyAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RealtyAssetResponseModelFromJson(json);

  @JsonKey(name: 'cost')
  final int cost;
  @JsonKey(name: 'downPayment')
  final int downPayment;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;

  Map<String, dynamic> toJson() => _$RealtyAssetResponseModelToJson(this);
}
