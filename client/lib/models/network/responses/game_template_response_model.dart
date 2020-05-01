import 'package:cash_flow/models/network/responses/account_state_response_model.dart';
import 'package:cash_flow/models/network/responses/target_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_template_response_model.g.dart';

@JsonSerializable()
class GameTemplateResponseModel {
  const GameTemplateResponseModel({
    this.id,
    this.name,
    this.target,
    this.accountState,
  });

  factory GameTemplateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GameTemplateResponseModelFromJson(json);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'target')
  final TargetResponseModel target;
  @JsonKey(name: 'accountState')
  final AccountStateResponseModel accountState;

  Map<String, dynamic> toJson() => _$GameTemplateResponseModelToJson(this);
}
