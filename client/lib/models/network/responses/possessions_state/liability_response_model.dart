import 'package:json_annotation/json_annotation.dart';

part 'liability_response_model.g.dart';

@JsonSerializable()
class LiabilityResponseModel {
  const LiabilityResponseModel({
    this.name,
    this.type,
    this.value,
  });

  factory LiabilityResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LiabilityResponseModelFromJson(json);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'type', defaultValue: LiabilityType.other)
  final LiabilityType type;
  @JsonKey(name: 'value')
  final int value;

  Map<String, dynamic> toJson() => _$LiabilityResponseModelToJson(this);
}

enum LiabilityType {
  @JsonValue('mortgage')
  mortgage,
  @JsonValue('business_credit')
  businessCredit,
  @JsonValue('other')
  other,
}
