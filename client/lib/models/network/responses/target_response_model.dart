import 'package:cash_flow/models/network/responses/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'target_response_model.g.dart';

@JsonSerializable()
class TargetResponseModel {
  const TargetResponseModel({
    this.name,
    this.type,
    this.value,
  });

  factory TargetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TargetResponseModelFromJson(json);

  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  @JsonKey(name: 'type', defaultValue: TargetType.cash)
  final TargetType type;
  @JsonKey(name: 'value', defaultValue: 0)
  final int value;

  Map<String, dynamic> toJson() => _$TargetResponseModelToJson(this);
}
