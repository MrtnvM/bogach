import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.uikit.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.uikit.dart';

import 'package:dash_kit_uikit/dash_kit_uikit.dart';

void configureUiKit() {
  UiKit.register(
    () => [
      UiComponentGroup('Game board', [
        BuySellBarBuilder(),
        ActionBarBuilder(),
      ]),
    ],
  );
}
