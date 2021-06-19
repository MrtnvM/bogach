import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/widgets/game_event/price_calculator.dart';
import 'package:dash_kit_uikit/dash_kit_uikit.dart';

class PriceCalculatorBuilder extends UiKitBuilder {
  @override
  Type get componentType => PriceCalculator;

  @override
  void buildComponentStates() {
    build(
      'Input Filed',
      const PriceCalculator(
        currentPrice: 1000,
        action: BuySellAction.buy(),
      ),
    );

    build(
      'Input Filed with initial count',
      const PriceCalculator(
        currentPrice: 1000,
        count: 5,
        action: BuySellAction.buy(),
      ),
    );
  }
}
