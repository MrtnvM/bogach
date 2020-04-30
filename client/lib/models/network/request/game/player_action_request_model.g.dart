// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_action_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerActionRequestModel _$PlayerActionRequestModelFromJson(
    Map<String, dynamic> json) {
  return PlayerActionRequestModel(
    gameContext: json['context'] == null
        ? null
        : GameContext.fromJson(json['context'] as Map<String, dynamic>),
    playerAction: json['action'] == null
        ? null
        : PlayerAction.fromJson(json['action'] as Map<String, dynamic>),
    eventId: json['eventId'] as String,
  );
}

Map<String, dynamic> _$PlayerActionRequestModelToJson(
        PlayerActionRequestModel instance) =>
    <String, dynamic>{
      'context': instance.gameContext?.toJson(),
      'action': instance.playerAction?.toJson(),
      'eventId': instance.eventId,
    };
