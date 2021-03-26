import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_change_player_action.g.dart';

@JsonSerializable()
class SalaryChangePlayerAction extends PlayerAction {
  const SalaryChangePlayerAction(this.eventId);

  final String eventId;

  @override
  Map<String, dynamic> toJson() => _$SalaryChangePlayerActionToJson(this);
}
