import 'package:freezed_annotation/freezed_annotation.dart';

part 'buy_sell_action.freezed.dart';

@freezed
abstract class BuySellAction with _$BuySellAction {
  const factory BuySellAction.buy() = BuyAction;
  const factory BuySellAction.sell() = SellAction;
}
