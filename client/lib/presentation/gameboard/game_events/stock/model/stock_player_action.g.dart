// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_player_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockPlayerAction _$StockPlayerActionFromJson(Map<String, dynamic> json) {
  return StockPlayerAction(
    BuySellAction.fromJson(json['action'] as String),
    json['count'] as int,
    json['eventId'] as String,
  );
}

Map<String, dynamic> _$StockPlayerActionToJson(StockPlayerAction instance) =>
    <String, dynamic>{
      'action': BuySellAction.toJson(instance.action),
      'count': instance.count,
      'eventId': instance.eventId,
    };
