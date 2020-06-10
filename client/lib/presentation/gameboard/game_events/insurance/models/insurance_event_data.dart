import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insurance_event_data.g.dart';
part 'insurance_event_data.freezed.dart';

@freezed
abstract class InsuranceEventData
    with _$InsuranceEventData
    implements GameEventData {
  factory InsuranceEventData({
    int cost,
    int value,
    int duration,
  }) = _InsuranceEventData;

  factory InsuranceEventData.fromJson(Map<String, dynamic> json) =>
      _$InsuranceEventDataFromJson(json);
}
