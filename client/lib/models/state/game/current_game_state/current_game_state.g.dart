// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CurrentGameState _$_$_CurrentGameStateFromJson(Map<String, dynamic> json) {
  return _$_CurrentGameState(
    gameStatus: _$enumDecodeNullable(_$GameStatusEnumMap, json['gameState']),
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
      'gameState': _$GameStatusEnumMap[instance.gameStatus],
      'monthNumber': instance.monthNumber,
      'participantProgress': instance.participantProgress,
      'winners': instance.winners?.map((k, e) => MapEntry(k.toString(), e)),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$GameStatusEnumMap = {
  GameStatus.playersMove: 'players_move',
  GameStatus.gameOver: 'game_over',
};
