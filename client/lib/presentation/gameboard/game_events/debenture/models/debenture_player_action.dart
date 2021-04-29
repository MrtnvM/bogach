import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debenture_player_action.g.dart';

@JsonSerializable()
class DebenturePlayerAction extends PlayerAction {
  const DebenturePlayerAction(this.action, this.count, this.eventId);

  @JsonKey(fromJson: BuySellAction.fromJson, toJson: BuySellAction.toJson)
  final BuySellAction action;
  final int? count;
  final String? eventId;

  @override
  Map<String, dynamic> toJson() => _$DebenturePlayerActionToJson(this);
}
