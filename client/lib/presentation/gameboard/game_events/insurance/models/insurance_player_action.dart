import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insurance_player_action.g.dart';

@JsonSerializable()
class InsurancePlayerAction extends PlayerAction {
  const InsurancePlayerAction(this.eventId) : assert(eventId != null);

  final String eventId;

  @override
  Map<String, dynamic> toJson() => _$InsurancePlayerActionToJson(this);
}
