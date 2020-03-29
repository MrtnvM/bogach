import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'insurance_asset_response_model.g.dart';

@JsonSerializable()
class InsuranceAssetResponseModel {
  const InsuranceAssetResponseModel({
    this.name,
    this.type,
    this.value,
  });

  factory InsuranceAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InsuranceAssetResponseModelFromJson(json);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;
  @JsonKey(name: 'value')
  final int value;

  Map<String, dynamic> toJson() => _$InsuranceAssetResponseModelToJson(this);
}
