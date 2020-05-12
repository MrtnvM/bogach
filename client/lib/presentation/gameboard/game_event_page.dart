import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/investment/ui/investment_game_event.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/events/stock_game_event.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:cash_flow/widgets/progress/connected_game_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class GameEventPage extends HookWidget {
  const GameEventPage({Key key, this.event}) : super(key: key);

  final GameEvent event;

  @override
  Widget build(BuildContext context) {
    final userId = useGlobalState((s) => s.login.currentUser.userId);
    final activeGameState = useGlobalState((s) => s.gameState.activeGameState);
    final account = useGlobalState(
      (s) => s.gameState.currentGame.accounts[userId],
    );
    final gameEvents = useGlobalState(
      (s) => s.gameState.currentGame.currentEvents,
    );

    final currentEvent = activeGameState.maybeMap(
      gameEvent: (eventState) => gameEvents[eventState.eventIndex],
      orElse: () => null,
    );

    final isMonthResult = activeGameState.maybeWhen(
      monthResult: () => true,
      orElse: () => false,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConnectedGameProgressBar(),
        AccountBar(account: account),
        if (isMonthResult) _buildMonthResult(),
        if (currentEvent != null) _buildEventBody(currentEvent),
      ],
    );
  }

  Widget _buildEventBody(GameEvent event) {
    if (event == null) {
      return Container();
    }

    final eventWidget = event.type.map(
      debenture: (_) => InvestmentGameEvent(event),
      stock: (_) => StockGameEvent(event),
    );

    return Expanded(
      child: ListView(
        children: [eventWidget],
      ),
    );
  }

  Widget _buildMonthResult() {
    final actionRunner = useActionRunner();
    final goToNewMonth = () => actionRunner.runAction(GoToNewMonthAction());

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
