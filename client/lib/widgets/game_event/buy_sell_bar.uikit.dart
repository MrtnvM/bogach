import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:uikit/uikit.dart';

class BuySellBarBuilder extends UiKitBuilder {
  @override
  Type get componentType => BuySellBar;

  @override
  void buildComponentStates() {
    build(
      'Buy Sell Bar',
      const BuySellBar(
        onActionChanged: print,
      ),
    );
  }
}
