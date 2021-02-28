import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_template_response_model.g.dart';

@JsonSerializable()
class GameTemplateResponseModel {
  const GameTemplateResponseModel({
    this.id,
    this.name,
    this.icon,
    this.image,
    this.target,
    this.accountState,
  });

  factory GameTemplateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GameTemplateResponseModelFromJson(json);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'image')
  final String image;
  @JsonKey(name: 'target')
  final Target target;
  @JsonKey(name: 'accountState')
  final Account accountState;

  Map<String, dynamic> toJson() => _$GameTemplateResponseModelToJson(this);
}
