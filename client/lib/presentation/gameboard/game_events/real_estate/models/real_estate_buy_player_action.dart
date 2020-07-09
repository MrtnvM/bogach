
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'real_estate_buy_player_action.g.dart';

@JsonSerializable()
class RealEstateBuyPlayerAction extends PlayerAction {
  const RealEstateBuyPlayerAction(this.eventId);

  final String eventId;

  @override
  Map<String, dynamic> toJson() => _$RealEstateBuyPlayerActionToJson(this);
}
