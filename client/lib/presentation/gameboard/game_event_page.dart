import 'package:cash_flow/presentation/gameboard/models/game_event.dart';
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
    return Container(
      child: Column(
        children: [
          _buildGoalProgress(),
        ],
      ),
    );
  }

  Widget _buildGoalProgress() {
    return Column(
      children: <Widget>[
        const Text('Goal Name'),
        Container(child: const LinearProgressIndicator(value: 0.5)),
      ],
    );
  }
}
