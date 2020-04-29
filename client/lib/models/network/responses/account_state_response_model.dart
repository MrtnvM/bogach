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
  final int cash;
  @JsonKey(name: 'cashFlow')
  final int cashFlow;
  @JsonKey(name: 'credit')
  final int credit;

  Map<String, dynamic> toJson() => _$AccountStateResponseModelToJson(this);
}
