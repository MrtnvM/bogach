// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CurrentGameState _$_$_CurrentGameStateFromJson(Map<String, dynamic> json) {
  return _$_CurrentGameState(
    gameState: json['gameState'] as String,
    monthNumber: json['monthNumber'] as int,
    participantProgress:
        (json['participantProgress'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    ),
    winners: (json['winners'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e as String),
    ),
  );
}

Map<String, dynamic> _$_$_CurrentGameStateToJson(
        _$_CurrentGameState instance) =>
    <String, dynamic>{
      'gameState': instance.gameState,
      'monthNumber': instance.monthNumber,
      'participantProgress': instance.participantProgress,
      'winners': instance.winners?.map((k, e) => MapEntry(k.toString(), e)),
    };
