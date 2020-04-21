import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/models/domain/player_action.dart';

class InvestmentPlayerAction extends PlayerAction {
  const InvestmentPlayerAction(this.action, this.count, this.eventId);

  final BuySellAction action;
  final int count;
  final String eventId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'action': action.map(buy: (_) => 'buy', sell: (_) => 'sell'),
      'count': count,
      'eventId': eventId,
    };
  }
}
