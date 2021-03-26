import 'package:freezed_annotation/freezed_annotation.dart';

part 'buy_sell_action.freezed.dart';

bool isBuyAction(BuySellAction action) => action == const BuySellAction.buy();
bool isSellAction(BuySellAction action) => action == const BuySellAction.sell();

@freezed
abstract class BuySellAction with _$BuySellAction {
  const factory BuySellAction.buy() = BuyAction;
  const factory BuySellAction.sell() = SellAction;

  static BuySellAction fromJson(String action) {
    switch (action) {
      case 'buy':
        return const BuySellAction.buy();

      case 'sell':
        return const BuySellAction.sell();

      default:
        throw Exception('Unknown buy sell action: $action');
    }
  }

  static String toJson(BuySellAction action) {
    return action.when(buy: () => 'buy', sell: () => 'sell');
  }
}
