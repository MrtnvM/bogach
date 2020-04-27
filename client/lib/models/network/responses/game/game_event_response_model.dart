import 'package:cash_flow/models/network/responses/game/game_event_data_response_model.dart';
import 'package:cash_flow/models/network/responses/game/game_event_type.dart';
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
  final GameEventDataResponseModel data;
  final GameEventType type;

  Map<String, dynamic> toJson() => _$GameEventResponseModelToJson(this);
}