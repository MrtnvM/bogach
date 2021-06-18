import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/ui/debenture_game_event_widget.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/ui/expense_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/ui/income_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/ui/insurance_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/monthly_payment/ui/monthly_expense_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/news/ui/news_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/ui/real_estate_buy_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/salary_change/ui/salary_change_game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/ui/stock_game_event.dart';
import 'package:cash_flow/presentation/gameboard/month_result_widget.dart';
import 'package:cash_flow/presentation/gameboard/tabs/actions_tab.dart';
import 'package:cash_flow/presentation/gameboard/waiting_players_card.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/selector_state.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'game_events/business/buy/ui/business_buy_game_event_widget.dart';
import 'game_events/business/sell/ui/business_sell_game_event_widget.dart';
import 'game_events/stock/ui/stock_game_event.dart';

class GameEventPage extends HookWidget {
  const GameEventPage({
    Key? key,
    required this.selectorState,
  }) : super(key: key);

  final ValueNotifier<SelectorState> selectorState;

  @override
  Widget build(BuildContext context) {
    final activeGameState = useCurrentActiveGameState()!;
    final gameEvents = useCurrentGame((g) => g!.currentEvents) ?? [];

    final isActionInProgress = useIsGameboardActionInProgress();

    return AnimatedOpacity(
      opacity: isActionInProgress ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      child: activeGameState.maybeWhen(
        gameEvent: (eventIndex, _) => gameEvents.isEmpty
            ? _buildNoGameEventsState()
            : _buildEventBody(gameEvents[eventIndex]),
        waitingPlayers: (_) => WaitingPlayersCard(),
        monthResult: () => const MonthResultWidget(),
        orElse: () => Container(),
      ),
    );
  }

  Widget _buildNoGameEventsState() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Text(
        Strings.noGameEvents,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEventBody(GameEvent event) {
    final eventWidget = event.type.map(
      debenture: (_) => DebentureGameEventWidget(event, selectorState),
      stock: (_) => StockGameEvent(event, selectorState),
      businessBuy: (_) => BusinessBuyGameEventWidget(event),
      businessSell: (_) => BusinessSellGameEventWidget(event, selectorState),
      income: (_) => IncomeGameEvent(event),
      expense: (_) => ExpenseGameEvent(event),
      monthlyExpense: (_) => MonthlyExpenseEvent(event),
      insurance: (_) => InsuranceGameEvent(event),
      realEstateBuy: (_) => RealEstateBuyGameEvent(event),
      salaryChange: (_) => SalaryChangeEvent(event),
      news: (_) => NewsGameEvent(event),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 74),
      child: eventWidget,
    );
  }
}
