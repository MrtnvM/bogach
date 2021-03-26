import 'package:cash_flow/widgets/game_event/price_calculator.dart';
import 'package:dash_kit_uikit/dash_kit_uikit.dart';

class PriceCalculatorBuilder extends UiKitBuilder {
  @override
  Type get componentType => PriceCalculator;

  @override
  void buildComponentStates() {
    build('Input Filed', const PriceCalculator(currentPrice: 1000));

    build(
      'Input Filed with initial count',
      const PriceCalculator(
        currentPrice: 1000,
        count: 5,
      ),
    );
  }
}
