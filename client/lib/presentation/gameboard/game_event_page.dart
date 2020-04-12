import 'dart:math';

import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/models/network/responses/target_type.dart';
import 'package:cash_flow/models/state/target_state.dart';
import 'package:cash_flow/presentation/gameboard/models/game_event.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/events/investment_game_event.dart';
import 'package:cash_flow/widgets/events/property_game_event.dart';
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

  Widget currentEvent = Container();

  @override
  void initState() {
    super.initState();
    buttonsProperties = ButtonsProperties(
      onConfirm: _generateNewEvent,
      onBuy: _generateNewEvent,
      onSkip: _generateNewEvent,
    );
    _generateNewEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildGoalProgress(),
        Expanded(child: ListView(children: [currentEvent])),
      ],
    );
  }

  Widget _buildGoalProgress() {
    return AppStateConnector<TargetState>(
        converter: (s) => s.gameState.target,
        builder: (context, state) => GameProgressBar(
              name: _getTargetType(state.type),
              currentValue: state.currentValue,
              maxValue: state.value,
            ));
  }

  Widget _buildPropertyEvent() {
    return PropertyGameEvent(
      PropertyViewModel(
        name: 'киоск',
        price: 83000,
        marketPrice: 100000,
        downPayment: 16500,
        debt: 66500,
        passiveIncomePerMonth: -100,
        roi: -7.3,
        saleRate: 14,
        buttonsProperties: buttonsProperties,
      ),
    );
  }

  Widget _buildInvestmentEvent() {
    return InvestmentGameEvent(
      InvestmentViewModel(
          currentPrice: 1200,
          type: 'Облигации',
          nominalCost: 1000,
          passiveIncomePerMonth: 40,
          roi: 40,
          alreadyHave: 1,
          maxCount: 15,
          buttonsProperties: buttonsProperties),
    );
  }

  void _generateNewEvent() {
    final nextInt = Random().nextInt(7);
    print(nextInt);
    switch (nextInt) {
      case 0:
        setState(() => currentEvent = _buildPropertyEvent());
        break;
      case 1:
        setState(() => currentEvent = _buildInvestmentEvent());
        break;
      case 2:
        setState(() => currentEvent = _buildPropertyEvent());
        break;
      case 3:
        setState(() => currentEvent = _buildInvestmentEvent());
        break;
      case 4:
        setState(() => currentEvent = _buildPropertyEvent());
        break;
      case 5:
        setState(() => currentEvent = _buildInvestmentEvent());
        break;
      case 6:
        setState(() => currentEvent = _buildPropertyEvent());
        break;
      default:
        setState(() {
          currentEvent = Container();
        });
        break;
    }
  }

  String _getTargetType(TargetType type) {
    switch (type) {
      case TargetType.cash:
        return Strings.targetTypeCash;
      default:
        return '';
    }
  }
}
