import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cash_asset_response_model.g.dart';

@JsonSerializable()
class CashAssetResponseModel {
  const CashAssetResponseModel({
    this.name,
    this.type,
    this.value,
  });

  factory CashAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CashAssetResponseModelFromJson(json);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;
  @JsonKey(name: 'value')
  final double value;

  Map<String, dynamic> toJson() => _$CashAssetResponseModelToJson(this);
}
