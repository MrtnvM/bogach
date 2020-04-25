import 'package:cash_flow/widgets/game_event/buy_sell_bar.uikit.dart';
import 'package:cash_flow/widgets/game_event/monthly_income.uikit.dart';
import 'package:cash_flow/widgets/game_event/price_calculator.uikit.dart';
import 'package:cash_flow/widgets/game_event/value_slider.uikit.dart';
import 'package:cash_flow/widgets/progress/account_bar.uikit.dart';

import 'package:uikit/uikit.dart';

void configureUiKit() {
  UiKit.register(
    () => [
      UiComponentGroup('Game board', [
        BuySellBarBuilder(),
        PriceCalculatorBuilder(),
        ValueSliderBuilder(),
        MonthlyIncomeWidgetBuilder(),
        AccountBarBuilder(),
      ]),
    ],
  );
}
