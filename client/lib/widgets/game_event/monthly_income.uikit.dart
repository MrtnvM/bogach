import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/widgets/game_event/monthly_income.dart';
import 'package:uikit/uikit.dart';

class MonthlyIncomeWidgetBuilder extends UiKitBuilder {
  @override
  Type get componentType => MonthlyIncomeWidget;

  @override
  void buildComponentStates() {
    build(
      'Positive income',
      const MonthlyIncomeWidget(
        action: BuySellAction.buy(),
        assetCount: 100,
        passiveIncomePerMonth: 40,
      ),
    );

    build(
      'Negative income',
      const MonthlyIncomeWidget(
        action: BuySellAction.sell(),
        assetCount: 100,
        passiveIncomePerMonth: 30,
      ),
    );
  }
}
