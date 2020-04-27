// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_event_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameEventResponseModel _$GameEventResponseModelFromJson(
    Map<String, dynamic> json) {
  return GameEventResponseModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    data: json['data'] == null
        ? null
        : GameEventDataResponseModel.fromJson(
            json['data'] as Map<String, dynamic>),
    type: _$enumDecodeNullable(_$GameEventTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$GameEventResponseModelToJson(
        GameEventResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'data': instance.data?.toJson(),
      'type': _$GameEventTypeEnumMap[instance.type],
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

const _$GameEventTypeEnumMap = {
  GameEventType.debenture: 'debenture-price-changed-event',
};
