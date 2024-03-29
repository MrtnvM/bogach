import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_buy_player_action.g.dart';

@JsonSerializable()
class BusinessBuyPlayerAction extends PlayerAction {
  const BusinessBuyPlayerAction(
    this.action,
    this.eventId,
    // ignore: avoid_positional_boolean_parameters
    this.inCredit,
  );

  @JsonKey(fromJson: BuySellAction.fromJson, toJson: BuySellAction.toJson)
  final BuySellAction action;
  final String? eventId;
  final bool inCredit;

  @override
  Map<String, dynamic> toJson() => _$BusinessBuyPlayerActionToJson(this);
}
