import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_expense_player_action.g.dart';

@JsonSerializable()
class MonthlyExpensePlayerAction extends PlayerAction {
  const MonthlyExpensePlayerAction(this.eventId);

  final String eventId;

  @override
  Map<String, dynamic> toJson() => _$MonthlyExpensePlayerActionToJson(this);
}
