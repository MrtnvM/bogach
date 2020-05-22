import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/ui/debenture_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/ui/expense_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/ui/income_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/ui/stock_game_event.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'game_events/business/buy/ui/business_buy_game_event.dart';
import 'game_events/stock/ui/stock_game_event.dart';

class GameEventPage extends HookWidget {
  const GameEventPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeGameState = useGlobalState((s) => s.gameState.activeGameState);
    final gameEvents = useCurrentGame((g) => g.currentEvents);
    final actionRunner = useActionRunner();

    final currentEvent = activeGameState.maybeMap(
      gameEvent: (eventState) => gameEvents[eventState.eventIndex],
      orElse: () => null,
    );

    final isMonthResult = activeGameState.maybeWhen(
      monthResult: () => true,
      orElse: () => false,
    );

    final goToNewMonth = () => actionRunner.runAction(GoToNewMonthAction());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMonthResult) _buildMonthResult(goToNewMonth),
        if (currentEvent != null) _buildEventBody(currentEvent),
      ],
    );
  }

  Widget _buildEventBody(GameEvent event) {
    return event.type.map(
      debenture: (_) => DebentureGameEvent(event: event),
      stock: (_) => StockGameEvent(event),
      businessBuy: (_) => BusinessBuyGameEvent(event),
      businessSell: (_) => BusinessSellGameEvent(event),
      income: (_) => IncomeGameEvent(event),
      expense: (_) => ExpenseGameEvent(event),
    );
  }

  Widget _buildMonthResult(VoidCallback goToNewMonth) {
    return Container(
      height: 250,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.monthIsOver,
              style: Styles.caption.copyWith(
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            RaisedButton(
              child: const Text(Strings.continueGame),
              onPressed: goToNewMonth,
            )
          ],
        ),
      ),
    );
  }
}
