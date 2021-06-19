import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_expense_event_data.freezed.dart';

part 'monthly_expense_event_data.g.dart';

@freezed
class MonthlyExpenseEventData
    with _$MonthlyExpenseEventData
    implements GameEventData {
  factory MonthlyExpenseEventData({
    required int monthlyPayment,
    required String expenseName,
  }) = _MonthlyExpenseEventData;

  factory MonthlyExpenseEventData.fromJson(Map<String, dynamic> json) =>
      _$MonthlyExpenseEventDataFromJson(json);
}
