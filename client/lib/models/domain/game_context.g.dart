// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameContext _$GameContextFromJson(Map<String, dynamic> json) {
  return GameContext(
    gameId: json['gameId'] as String,
    userId: json['userId'] as String,
  );
}

Map<String, dynamic> _$GameContextToJson(GameContext instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'gameId': instance.gameId,
    };
