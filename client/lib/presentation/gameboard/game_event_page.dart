import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/game_events/investment/ui/investment_game_event.dart';
import 'package:cash_flow/models/domain/game_event.dart';
import 'package:cash_flow/models/network/responses/target_type.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:cash_flow/widgets/progress/game_progress_bar.dart';
import 'package:flutter/material.dart';

class GameEventPage extends StatefulWidget {
  const GameEventPage({Key key, this.event}) : super(key: key);

  final GameEvent event;

  @override
  _GameEventPageState createState() => _GameEventPageState();
}

class _GameEventPageState extends State<GameEventPage> {
  @override
  Widget build(BuildContext context) {
    return AppStateConnector<GameState>(
      converter: (s) => s.gameState,
      builder: (context, state) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GameProgressBar(
            name: _getTargetType(state.target.type),
            currentValue: state.target.currentValue,
            maxValue: state.target.value,
          ),
          AccountBar(account: state.account),
          _buildEventBody(state.events.first),
        ],
      ),
    );
  }

  String _getTargetType(TargetType type) {
    final typeNames = {
      TargetType.cash: Strings.targetTypeCash,
    };

    return typeNames[type] ?? '';
  }

  Widget _buildEventBody(GameEvent event) {
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
}
