import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/ui/debenture_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/ui/expense_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/ui/income_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/ui/insurance_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/monthly_payment/ui/monthly_expense_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/ui/stock_game_event.dart';
import 'package:cash_flow/presentation/gameboard/month_result_card.dart';
import 'package:cash_flow/presentation/gameboard/waiting_players_card.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar_button.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'game_events/business/buy/ui/business_buy_game_event.dart';
import 'game_events/business/sell/ui/business_sell_game_event.dart';
import 'game_events/stock/ui/stock_game_event.dart';

class GameEventPage extends HookWidget {
  const GameEventPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeGameState = useGlobalState((s) => s.game.activeGameState);
    final gameEvents = useCurrentGame((g) => g.currentEvents);
    final gameActions = useGameActions();
    final participantProgress = useCurrentGame(
      (g) => g.state.participantsProgress,
    );

    final currentEvent = activeGameState.maybeMap(
      gameEvent: (eventState) => gameEvents[eventState.eventIndex],
      orElse: () => null,
    );

    final isMonthResult = activeGameState.maybeWhen(
      monthResult: () => true,
      orElse: () => false,
    );

    final isWaitingPlayers = isMonthResult &&
        participantProgress.values.any(
          (e) => e.status != ParticipantProgressStatus.monthResult,
        );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isWaitingPlayers) WaitingPlayersCard(),
        if (!isWaitingPlayers && isMonthResult)
          _buildMonthResult(gameActions.startNewMonth),
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
      monthlyExpense: (_) => MonthlyExpenseEvent(event),
      insurance: (_) => InsuranceGameEvent(event),
    );
  }

  Widget _buildMonthResult(VoidCallback goToNewMonth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MonthResultCard(),
        const SizedBox(height: 32),
        ActionBarButton(
          text: Strings.continueGame,
          color: Colors.green,
          onPressed: goToNewMonth,
        )
      ],
    );
  }
}
