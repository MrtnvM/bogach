import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'income_event_data.freezed.dart';

part 'income_event_data.g.dart';

@freezed
abstract class IncomeEventData with _$IncomeEventData implements GameEventData {
  factory IncomeEventData({
    int income,
  }) = _IncomeEventData;

  factory IncomeEventData.fromJson(Map<String, dynamic> json) =>
      _$IncomeEventDataFromJson(json);
}
