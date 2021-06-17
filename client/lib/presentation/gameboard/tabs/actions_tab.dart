import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_event_page.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/ui/business_buy_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/ui/debenture_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/ui/expense_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/ui/income_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/ui/insurance_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/monthly_payment/ui/monthly_expense_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/news/ui/news_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/ui/real_estate_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/salary_change/ui/salary_change_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/ui/stock_action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/top_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/selector_state.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ActionsTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectorState = useState(SelectorState.zero);
    final gameEvents = useCurrentGame((g) => g!.currentEvents) ?? [];
    final isLoading = useIsGameboardActionInProgress();
    final scrollController = useScrollController();
    final activeGameState = useCurrentActiveGameState()!;
    final isActionInProgress = useIsGameboardActionInProgress();

    final currenEventIndex = activeGameState.maybeWhen(
      gameEvent: (eventIndex, sendingEventIndex) => eventIndex,
      orElse: () => -1,
    );

    useEffect(() {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }

      return null;
    }, [currenEventIndex]);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                    16, 12 + TopBar.bottomOffset, 16, 20),
                children: [
                  GameEventPage(selectorState: selectorState),
                ],
              ),
              activeGameState.maybeWhen(
                gameEvent: (eventIndex, _) => gameEvents.isEmpty
                    ? Container()
                    : _buildPlayerActionBar(
                        context,
                        gameEvents[eventIndex],
                        selectorState,
                        isActionInProgress,
                      ),
                orElse: () => Container(),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorRes.mainGreen),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerActionBar(
    BuildContext context,
    GameEvent event,
    ValueNotifier<SelectorState> selectorState,
    bool isActionInProgress,
  ) {
    final actionBar = event.type.map(
      debenture: (_) => DebentureActionBar(
        event: event,
        selectorState: selectorState,
      ),
      stock: (_) => StockActionBar(event: event, selectorState: selectorState),
      businessBuy: (_) => BusinessBuyActionBar(event: event),
      businessSell: (_) => BusinessSellActionBar(
        event: event,
        selectorState: selectorState,
      ),
      income: (_) => IncomeActionBar(event: event),
      expense: (_) => ExpenseActionBar(event: event),
      monthlyExpense: (_) => MonthlyExpenseActionBar(event: event),
      insurance: (_) => InsuranceActionBar(event: event),
      realEstateBuy: (_) => RealEstateActionBar(event: event),
      salaryChange: (_) => SalaryChangeActionBar(event: event),
      news: (_) => NewsGameActionBar(event: event),
    );

    return Positioned(
      bottom: 12,
      height: 48,
      left: 16,
      right: 16,
      child: AnimatedOpacity(
        opacity: isActionInProgress ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        child: actionBar,
      ),
    );
  }
}

bool useIsGameboardActionInProgress() {
  final gameId = useCurrentGameId();
  final isActionInProgress = useGlobalState((s) {
    final activeGameState = s.game.activeGameStates[gameId];
    final isStartingNewMonth =
        s.getOperationState(Operation.startNewMonth).isInProgress;

    final isSendingTurnEvent = activeGameState?.maybeWhen(
          gameEvent: (eventIndex, sendingEventIndex) =>
              eventIndex == sendingEventIndex,
          orElse: () => false,
        ) ??
        false;

    return isSendingTurnEvent || isStartingNewMonth;
  });

  return isActionInProgress ?? false;
}
