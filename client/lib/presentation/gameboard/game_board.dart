import 'package:cash_flow/presentation/gameboard/cash_flow_grid.dart';
import 'package:cash_flow/presentation/gameboard/game_event_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GameBoard')),
      body: Row(
        children: [
          Expanded(child: CashFlowGrid()),
          const VerticalDivider(width: 0, thickness: 0),
          const Expanded(child: GameEventPage()),
        ],
      ),
    );
  }
}
