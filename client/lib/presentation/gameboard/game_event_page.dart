import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/game_events/investment/ui/investment_game_event.dart';
import 'package:cash_flow/models/domain/game_event.dart';
import 'package:cash_flow/models/network/responses/target_type.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:cash_flow/widgets/progress/game_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class GameEventPage extends StatefulWidget {
  const GameEventPage({Key key, this.event}) : super(key: key);

  final GameEvent event;

  @override
  _GameEventPageState createState() => _GameEventPageState();
}

class _GameEventPageState extends State<GameEventPage> with ReduxState {
  @override
  Widget build(BuildContext context) {
    return AppStateConnector<GameState>(
      converter: (s) => s.gameState,
      builder: (context, state) {
        final currentEvent = state.activeGameState.map(
          waitingForStart: (_) => null,
          gameEvent: (eventState) => state.events.firstWhere(
            (e) => eventState.eventId == e.id,
          ),
          waitingPlayers: (_) => null,
          monthResult: (_) => null,
          gameOver: (_) => null,
        );

        final isMonthResult = state.activeGameState.maybeWhen(
          monthResult: () => true,
          orElse: () => false,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GameProgressBar(
              name: _getTargetType(state.target.type),
              currentValue: state.target.currentValue,
              maxValue: state.target.value,
            ),
            AccountBar(account: state.account),
            if (isMonthResult) _buildMonthResult(),
            if (currentEvent != null) _buildEventBody(currentEvent),
          ],
        );
      },
    );
  }

  String _getTargetType(TargetType type) {
    final typeNames = {
      TargetType.cash: Strings.targetTypeCash,
    };

    return typeNames[type] ?? '';
  }

  Widget _buildEventBody(GameEvent event) {
    if (event == null) {
      return Container();
    }

    final eventWidget = event.type.map(
      debenture: (_) => InvestmentGameEvent(event),
      stock: (_) => null,
    );

    return Expanded(
      child: ListView(
        children: [eventWidget],
      ),
    );
  }

  Widget _buildMonthResult() {
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
              child: Text(Strings.continueGame),
              onPressed: () => dispatch(GoToNewMonthAction()),
            )
          ],
        ),
      ),
    );
  }
}
