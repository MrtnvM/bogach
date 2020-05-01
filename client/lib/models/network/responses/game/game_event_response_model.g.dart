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
    data: json['data'] as Map<String, dynamic>,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$GameEventResponseModelToJson(
        GameEventResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'data': instance.data,
      'type': instance.type,
    };
