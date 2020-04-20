import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/network/responses/target_type.dart';
import 'package:cash_flow/models/state/game/game_event.dart';
import 'package:cash_flow/models/state/target_state.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/events/investment_game_event.dart';
import 'package:cash_flow/widgets/progress/game_progress_bar.dart';
import 'package:flutter/material.dart';

class GameEventPage extends StatefulWidget {
  const GameEventPage({Key key, this.event}) : super(key: key);

  final GameEvent event;

  @override
  _GameEventPageState createState() => _GameEventPageState();
}

class _GameEventPageState extends State<GameEventPage> {
  ButtonsProperties buttonsProperties;

  @override
  void initState() {
    super.initState();
    buttonsProperties = ButtonsProperties(
      onConfirm: () {},
      onBuy: () {},
      onSkip: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppStateConnector<GameState>(
      converter: (s) => s.gameState,
      builder: (context, state) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildGoalProgress(state.target),
          _buildEventBody(state.events.first),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(TargetState target) {
    return GameProgressBar(
      name: _getTargetType(target.type),
      currentValue: target.currentValue,
      maxValue: target.value,
    );
  }

  String _getTargetType(TargetType type) {
    final typeNames = {
      TargetType.cash: Strings.targetTypeCash,
    };

    return typeNames[type] ?? '';
  }

  Widget _buildEventBody(GameEvent event) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          InvestmentGameEvent(
            InvestmentViewModel(
              currentPrice: event.data.currentPrice,
              type: event.name,
              nominalCost: event.data.nominal,
              // TODO(Artem): How to calculate this
              passiveIncomePerMonth: 40,
              roi: event.data.profitabilityPercent.toDouble(),
              // TODO(Artem): How to calculate this
              alreadyHave: 1,
              maxCount: event.data.maxCount,
              buttonsProperties: buttonsProperties,
            ),
          ),
        ],
      ),
    );
  }
}
