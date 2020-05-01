import 'package:cash_flow/models/domain/game_template.dart';
import 'package:cash_flow/resources/strings.dart';
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
    return GestureDetector(
      onTap: () => onGamePressed(game),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${game.name} — ${game.accountState.cash}${Strings.rubleSymbol}',
            ),
            const SizedBox(height: 20),
            Text('Цель — ${game.target.value}${Strings.rubleSymbol}'),
          ],
        ),
      ),
    );
  }
}
