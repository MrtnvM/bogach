import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'debenture_event_data.freezed.dart';
part 'debenture_event_data.g.dart';

@freezed
class DebentureEventData
    with _$DebentureEventData
    implements GameEventData {
  factory DebentureEventData({
    required double currentPrice,
    required double nominal,
    required double profitabilityPercent,
    required int availableCount,
  }) = _DebentureEventData;

  factory DebentureEventData.fromJson(Map<String, dynamic> json) =>
      _$DebentureEventDataFromJson(json);
}
