import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:dash_kit_uikit/dash_kit_uikit.dart';

class BuySellBarBuilder extends UiKitBuilder {
  @override
  Type get componentType => BuySellBar;

  @override
  void buildComponentStates() {
    build(
      'Buy action selected',
      const BuySellBar(
        selectedAction: BuySellAction.buy(),
        onActionChanged: print,
      ),
    );

    build(
      'Sell action selected',
      const BuySellBar(
        selectedAction: BuySellAction.sell(),
        onActionChanged: print,
      ),
    );
  }
}
