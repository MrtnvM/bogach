// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_event_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InvestmentEventData _$_$_InvestmentEventDataFromJson(
    Map<String, dynamic> json) {
  return _$_InvestmentEventData(
    currentPrice: json['currentPrice'] as int,
    availableCount: json['availableCount'] as int,
    nominal: json['nominal'] as int,
    profitabilityPercent: json['profitabilityPercent'] as int,
  );
}

Map<String, dynamic> _$_$_InvestmentEventDataToJson(
        _$_InvestmentEventData instance) =>
    <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'availableCount': instance.availableCount,
      'nominal': instance.nominal,
      'profitabilityPercent': instance.profitabilityPercent,
    };
