import 'package:cash_flow/widgets/game_event/price_input_field.dart';
import 'package:uikit/uikit.dart';

class PriceInputFieldBuilder extends UiKitBuilder {
  @override
  Type get componentType => PriceInputField;

  @override
  void buildComponentStates() {
    build('Input Filed', const PriceInputField(currentPrice: 1000));

    build(
      'Input Filed with initial count',
      const PriceInputField(
        currentPrice: 1000,
        initialCount: 5,
      ),
    );
  }
}
