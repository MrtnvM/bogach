
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_sell_player_action.g.dart';

@JsonSerializable()
class BusinessSellPlayerAction extends PlayerAction {
  const BusinessSellPlayerAction(this.action, this.eventId);

  @JsonKey(fromJson: BuySellAction.fromJson, toJson: BuySellAction.toJson)
  final BuySellAction action;
  final String eventId;

  @override
  Map<String, dynamic> toJson() => _$BusinessSellPlayerActionToJson(this);
}
