import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class GameLevelItem extends StatelessWidget {
  const GameLevelItem({
    @required this.gameLevel,
    @required this.onLevelSelected,
  });

  final GameLevel gameLevel;
  final void Function(GameLevel) onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onLevelSelected(gameLevel),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 16,
          right: 16,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('${gameLevel.name}', style: Styles.bodyBlackBold),
                ),
                const SizedBox(width: 16),
                getTemplateIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTemplateIcon() {
    return Image.network(
      gameLevel.icon,
      height: 38,
      width: 38,
    );
  }
}
