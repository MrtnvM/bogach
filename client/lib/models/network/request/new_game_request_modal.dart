import 'package:json_annotation/json_annotation.dart';

part 'new_game_request_modal.g.dart';

@JsonSerializable()
class NewGameRequestModel {
  const NewGameRequestModel({
    this.templateId,
    this.userId,
  });

  factory NewGameRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NewGameRequestModelFromJson(json);

  @JsonKey(name: 'templateId')
  final int? templateId;

  @JsonKey(name: 'userId')
  final int? userId;

  Map<String, dynamic> toJson() => _$NewGameRequestModelToJson(this);
}
