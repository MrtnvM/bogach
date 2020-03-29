import 'package:json_annotation/json_annotation.dart';

part 'expense_response_model.g.dart';

@JsonSerializable()
class ExpenseResponseModel {
  const ExpenseResponseModel({
    this.name,
    this.value,
  });

  factory ExpenseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseResponseModelFromJson(json);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'value')
  final int value;

  Map<String, dynamic> toJson() => _$ExpenseResponseModelToJson(this);
}
