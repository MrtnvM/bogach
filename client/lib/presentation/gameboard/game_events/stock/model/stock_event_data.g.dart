// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_event_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StockEventData _$_$_StockEventDataFromJson(Map<String, dynamic> json) {
  return _$_StockEventData(
    currentPrice: json['currentPrice'] as int,
    availableCount: json['availableCount'] as int,
    nominal: json['nominal'] as int,
  );
}

Map<String, dynamic> _$_$_StockEventDataToJson(_$_StockEventData instance) =>
    <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'availableCount': instance.availableCount,
      'nominal': instance.nominal,
    };
