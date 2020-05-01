import 'package:json_annotation/json_annotation.dart';

part 'account_state_response_model.g.dart';

@JsonSerializable()
class AccountStateResponseModel {
  const AccountStateResponseModel({
    this.cash,
    this.cashFlow,
    this.credit,
  });

  factory AccountStateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccountStateResponseModelFromJson(json);

  @JsonKey(name: 'cash')
  final double cash;
  @JsonKey(name: 'cashFlow')
  final double cashFlow;
  @JsonKey(name: 'credit')
  final double credit;

  Map<String, dynamic> toJson() => _$AccountStateResponseModelToJson(this);
}
