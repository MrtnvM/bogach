import 'package:json_annotation/json_annotation.dart';

part 'game_event_response_model.g.dart';

@JsonSerializable()
class GameEventResponseModel {
  const GameEventResponseModel({
    this.id,
    this.name,
    this.description,
    this.data,
    this.type,
  });

  factory GameEventResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GameEventResponseModelFromJson(json);

  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> data;
  final String type;

  Map<String, dynamic> toJson() => _$GameEventResponseModelToJson(this);
}
