import 'package:cash_flow/models/domain/game_template.dart';
import 'package:flutter/material.dart';

class TemplateGameItem extends StatelessWidget {
  const TemplateGameItem({
    @required this.game,
    @required this.onGamePressed,
  });

  final GameTemplate game;
  final void Function(GameTemplate game) onGamePressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: <Widget>[
          Text(game.name),
        ],
      ),
    );
  }
}
