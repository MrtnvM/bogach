import 'package:json_annotation/json_annotation.dart';

part 'asset_response_model.g.dart';

@JsonSerializable()
class AssetResponseModel {
  const AssetResponseModel({
    this.type,
  });

  factory AssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseModelFromJson(json);

  @JsonKey(
    name: 'type',
    defaultValue: AssetType.other,
    unknownEnumValue: AssetType.other,
  )
  final AssetType type;

  Map<String, dynamic> toJson() => _$AssetResponseModelToJson(this);
}

enum AssetType {
  @JsonValue('debenture')
  debenture,
  @JsonValue('insurance')
  insurance,
  @JsonValue('stock')
  stock,
  @JsonValue('realty')
  realty,
  @JsonValue('business')
  business,
  @JsonValue('cash')
  cash,
  @JsonValue('other')
  other,
}
