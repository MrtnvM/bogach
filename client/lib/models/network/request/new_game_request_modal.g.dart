// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_game_request_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewGameRequestModel _$NewGameRequestModelFromJson(Map<String, dynamic> json) {
  return NewGameRequestModel(
    templateId: json['templateId'] as int,
    userId: json['userId'] as int,
  );
}

Map<String, dynamic> _$NewGameRequestModelToJson(
        NewGameRequestModel instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'userId': instance.userId,
    };
