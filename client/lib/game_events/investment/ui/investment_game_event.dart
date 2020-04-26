import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/game_events/investment/models/investment_event_data.dart';
import 'package:cash_flow/game_events/investment/models/investment_player_action.dart';
import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/models/domain/game_event.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/game_event_selector.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class InvestmentGameEvent extends StatefulWidget {
  const InvestmentGameEvent(this.event);

  final GameEvent event;

  @override
  State<StatefulWidget> createState() {
    return InvestmentGameEventState();
  }
}

class InvestmentGameEventState extends State<InvestmentGameEvent>
    with ReduxState {
  var _selectedCount = 0;
  var _buySellAction = const BuySellAction.buy();

  GameEvent get event => widget.event;
  InvestmentEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    return GameEventWidget(
      icon: Icons.home,
      name: Strings.investments,
      buttonsState: ButtonsState.normal,
      buttonsProperties: ButtonsProperties(onConfirm: sendPlayerAction),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSellingPrice(),
          const SizedBox(height: 4),
          _buildInfo(),
          _buildSelector(),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    // TODO(maxim-martynov): Replace with real value
    const alreadyHave = 0;

    final map = {
      Strings.investmentType: event.type.typeTitle(),
      Strings.nominalCost: eventData.nominal.toPrice(),
      Strings.passiveIncomePerMonth: eventData.profitabilityPercent.toPrice(),
      Strings.roi: (eventData.profitabilityPercent * 12).toPercent(),
      Strings.alreadyHave: alreadyHave == 0
          ? alreadyHave.toString()
          : Strings.getUserAvailableCount(
              alreadyHave.toString(),
              eventData.currentPrice.toPrice(),
            ),
    };

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: InfoTable(map),
    );
  }

  Widget _buildSellingPrice() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: Strings.currentPrice,
              style: Styles.body1.copyWith(color: Colors.black87),
            ),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(
              text: eventData.currentPrice.toPrice(),
              style: Styles.body2.copyWith(color: ColorRes.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector() {
    const alreadyHave = 0;

    final selectorViewModel = SelectorViewModel(
      currentPrice: eventData.currentPrice,
      passiveIncomePerMonth: eventData.profitabilityPercent,
      alreadyHave: alreadyHave,
      maxCount: eventData.maxCount,
      changeableType: true,
    );

    return GameEventSelector(
      viewModel: selectorViewModel,
      onPlayerActionParamsChanged: (action, count) {
        _selectedCount = count;
        _buySellAction = action;
      },
    );
  }

  void sendPlayerAction() {
    final playerAction = InvestmentPlayerAction(
      _buySellAction,
      _selectedCount,
      event.id,
    );

    final action = SendGameEventPlayerActionAsyncAction(playerAction, event.id);

    dispatchAsyncAction(action).listen(
      (action) => action
        ..onSuccess((_) => null)
        ..onError(
          (error) => showCashDialog(
            context: context,
            title: 'Ееееепс!',
            message: 'Вот это вот случилось: $error',
          ),
        ),
    );
  }
}
