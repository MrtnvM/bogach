import 'package:json_annotation/json_annotation.dart';

part 'income_response_model.g.dart';

@JsonSerializable()
class IncomeResponseModel {
  const IncomeResponseModel({
    this.name,
    this.type,
    this.value,
  });

  factory IncomeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeResponseModelFromJson(json);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'type', defaultValue: IncomeType.other)
  final IncomeType type;
  @JsonKey(name: 'value')
  final int value;

  Map<String, dynamic> toJson() => _$IncomeResponseModelToJson(this);
}

enum IncomeType {
  @JsonValue('business')
  business,
  @JsonValue('salary')
  salary,
  @JsonValue('investment')
  investment,
  @JsonValue('realty')
  realty,
  @JsonValue('other')
  other,
}
