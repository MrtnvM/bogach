// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_template_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameTemplateResponseModel _$GameTemplateResponseModelFromJson(
    Map<String, dynamic> json) {
  return GameTemplateResponseModel(
    id: json['id'] as String,
    name: json['name'] as String,
    target: json['target'] == null
        ? null
        : TargetResponseModel.fromJson(json['target'] as Map<String, dynamic>),
    accountState: json['accountState'] == null
        ? null
        : AccountStateResponseModel.fromJson(
            json['accountState'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GameTemplateResponseModelToJson(
        GameTemplateResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'target': instance.target?.toJson(),
      'accountState': instance.accountState?.toJson(),
    };
