import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debenture_asset_response_model.g.dart';

@JsonSerializable()
class DebentureAssetResponseModel {
  const DebentureAssetResponseModel({
    this.name,
    this.type,
    this.count,
    this.currentPrice,
    this.nominal,
  });

  factory DebentureAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DebentureAssetResponseModelFromJson(json);

  final String name;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;
  final int count;
  final int nominal;
  final int currentPrice;

  Map<String, dynamic> toJson() => _$DebentureAssetResponseModelToJson(this);
}
