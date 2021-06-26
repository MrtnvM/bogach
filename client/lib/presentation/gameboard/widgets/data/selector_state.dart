import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';

class SelectorState {
  const SelectorState({
    required this.action,
    required this.count,
    this.selectedItemId,
  });

  final BuySellAction action;
  final int count;
  final String? selectedItemId;

  static const zero = SelectorState(action: BuySellAction.buy(), count: 0);
}
