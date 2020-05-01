// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_player_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentPlayerAction _$InvestmentPlayerActionFromJson(
    Map<String, dynamic> json) {
  return InvestmentPlayerAction(
    BuySellAction.fromJson(json['action'] as String),
    json['count'] as int,
    json['eventId'] as String,
  );
}

Map<String, dynamic> _$InvestmentPlayerActionToJson(
        InvestmentPlayerAction instance) =>
    <String, dynamic>{
      'action': BuySellAction.toJson(instance.action),
      'count': instance.count,
      'eventId': instance.eventId,
    };
