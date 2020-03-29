import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'other_asset_response_model.g.dart';

@JsonSerializable()
class OtherAssetResponseModel {
  const OtherAssetResponseModel({
    this.cost,
    this.downPayment,
    this.name,
    this.type,
  });

  factory OtherAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtherAssetResponseModelFromJson(json);

  @JsonKey(name: 'cost')
  final int cost;
  @JsonKey(name: 'downPayment')
  final int downPayment;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;

  Map<String, dynamic> toJson() => _$OtherAssetResponseModelToJson(this);
}
