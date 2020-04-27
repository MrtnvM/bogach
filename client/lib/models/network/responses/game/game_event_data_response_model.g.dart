// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_event_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameEventDataResponseModel _$GameEventDataResponseModelFromJson(
    Map<String, dynamic> json) {
  return GameEventDataResponseModel(
    currentPrice: json['currentPrice'] as int,
    maxCount: json['maxCount'] as int,
    nominal: json['nominal'] as int,
    profitabilityPercent: json['profitabilityPercent'] as int,
  );
}

Map<String, dynamic> _$GameEventDataResponseModelToJson(
        GameEventDataResponseModel instance) =>
    <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'maxCount': instance.maxCount,
      'nominal': instance.nominal,
      'profitabilityPercent': instance.profitabilityPercent,
    };
