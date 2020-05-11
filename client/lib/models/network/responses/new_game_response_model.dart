import 'package:json_annotation/json_annotation.dart';

part 'new_game_response_model.g.dart';

@JsonSerializable()
class NewGameResponseModel {
  const NewGameResponseModel({
    this.id,
  });

  factory NewGameResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewGameResponseModelFromJson(json);

  @JsonKey(name: 'id')
  final String id;

  Map<String, dynamic> toJson() => _$NewGameResponseModelToJson(this);
}
