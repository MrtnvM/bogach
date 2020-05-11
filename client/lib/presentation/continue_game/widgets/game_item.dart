import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameItem extends HookWidget {
  const GameItem({
    @required this.game,
    @required this.onGameSelected,
  });

  final Game game;
  final void Function(Game) onGameSelected;

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final cash = game.accounts[userId].cash;

    final gameTarget = game.target;
    final targetTitle = mapTargetTypeToString(gameTarget.type).toLowerCase();
    final targetValue = gameTarget.value.round().toPrice();

    return GestureDetector(
      onTap: () => onGameSelected(game),
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
              '${game.name} — ${cash.round().toPrice()}',
              style: Styles.bodyBlackBold,
            ),
            const SizedBox(height: 20),
            Text(
              '${Strings.reach} $targetTitle '
              '${Strings.wordIn} $targetValue',
              style: Styles.bodyBlack,
            ),
          ],
        ),
      ),
    );
  }
}
