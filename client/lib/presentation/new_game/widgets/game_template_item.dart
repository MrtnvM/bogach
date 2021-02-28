import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameTemplateItem extends HookWidget {
  const GameTemplateItem({
    @required this.gameTemplate,
    @required this.onStartNewGamePressed,
    this.onContinueGamePressed,
  });

  final GameTemplate gameTemplate;
  final void Function(GameTemplate) onStartNewGamePressed;
  final void Function(GameTemplate) onContinueGamePressed;

  @override
  Widget build(BuildContext context) {
    final isCollapsed = useState(false);

    final gameTarget = gameTemplate.target;
    final targetTitle = mapTargetTypeToString(gameTarget.type).toLowerCase();
    final targetValue = gameTarget.value.round().toPrice();
    final description = '${Strings.reach} $targetTitle '
        '${Strings.wordIn} $targetValue';

    final startGame = () {
      onStartNewGamePressed(gameTemplate);
      isCollapsed.value = false;
    };

    final continueGame = () {
      onContinueGamePressed(gameTemplate);
      isCollapsed.value = false;
    };

    return GameCard(
      title: gameTemplate.name,
      description: description,
      imageUrl: gameTemplate.image,
      startGame: startGame,
      continueGame: continueGame,
      isCollapsed: isCollapsed.value,
      onTap: () {
        if (continueGame == null) {
          startGame();
        } else {
          isCollapsed.value = !isCollapsed.value;
        }
      },
    );
  }
}
