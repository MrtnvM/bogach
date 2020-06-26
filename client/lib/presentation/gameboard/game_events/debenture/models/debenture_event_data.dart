import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'debenture_event_data.freezed.dart';
part 'debenture_event_data.g.dart';

@freezed
abstract class DebentureEventData
    with _$DebentureEventData
    implements GameEventData {
  factory DebentureEventData({
    double currentPrice,
    double nominal,
    double profitabilityPercent,
    int availableCount,
  }) = _DebentureEventData;

  factory DebentureEventData.fromJson(Map<String, dynamic> json) =>
      _$DebentureEventDataFromJson(json);
}
