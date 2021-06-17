import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_change_event_data.freezed.dart';

part 'salary_change_event_data.g.dart';

@freezed
class SalaryChangeEventData
    with _$SalaryChangeEventData
    implements GameEventData {
  factory SalaryChangeEventData({required double value}) =
      _SalaryChangeEventData;

  factory SalaryChangeEventData.fromJson(Map<String, dynamic> json) =>
      _$SalaryChangeEventDataFromJson(json);
}
