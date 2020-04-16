import 'package:cash_flow/widgets/game_event/buy_sell_bar.uikit.dart';
import 'package:cash_flow/widgets/game_event/price_input_field.uikit.dart';

import 'package:uikit/uikit.dart';

void configureUiKit() {
  UiKit.register(
    () => [
      UiComponentGroup('Game board', [
        BuySellBarBuilder(),
        PriceInputFieldBuilder(),
      ]),
    ],
  );
}
