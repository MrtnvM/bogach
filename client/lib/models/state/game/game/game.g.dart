// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Game _$_$_GameFromJson(Map<String, dynamic> json) {
  return _$_Game(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    state: json['state'] == null
        ? null
        : CurrentGameState.fromJson(json['state'] as Map<String, dynamic>),
    participants:
        (json['participants'] as List)?.map((e) => e as String)?.toList(),
    possessionState: (json['possessionState'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : PossessionState.fromJson(e as Map<String, dynamic>)),
    ),
    accounts: (json['accounts'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Account.fromJson(e as Map<String, dynamic>)),
    ),
    target: json['target'] == null
        ? null
        : Target.fromJson(json['target'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_GameToJson(_$_Game instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'state': instance.state?.toJson(),
      'participants': instance.participants,
      'possessionState':
          instance.possessionState?.map((k, e) => MapEntry(k, e?.toJson())),
      'accounts': instance.accounts?.map((k, e) => MapEntry(k, e?.toJson())),
      'target': instance.target?.toJson(),
    };
