import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'investment_event_data.freezed.dart';
part 'investment_event_data.g.dart';

@freezed
abstract class InvestmentEventData
    with _$InvestmentEventData
    implements GameEventData {
  factory InvestmentEventData({
    int currentPrice,
    int availableCount,
    int nominal,
    int profitabilityPercent,
  }) = _InvestmentEventData;

  factory InvestmentEventData.fromJson(Map<String, dynamic> json) =>
      _$InvestmentEventDataFromJson(json);
}
