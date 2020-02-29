import 'dart:math';

import 'package:cash_flow/presentation/gameboard/models/game_event.dart';
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
  Widget currentEvent = Container();

  @override
  void initState() {
    super.initState();
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
    return const GameProgressBar('Капитал', 2772, 50000);
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
        onConfirm: _generateNewEvent,
        onSkip: _generateNewEvent,
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
        onConfirm: _generateNewEvent,
        onSkip: _generateNewEvent,
      ),
    );
  }

  void _generateNewEvent() {
    final nextInt = Random().nextInt(2);
    print(nextInt);
    switch (nextInt) {
      case 0:
        {
          setState(() {
            currentEvent = _buildPropertyEvent();
          });
          break;
        }
      case 1:
        {
          setState(() {
            currentEvent = _buildInvestmentEvent();
          });
          break;
        }
      default:
        setState(() {
          currentEvent = Container();
        });
        break;
    }
  }
}
