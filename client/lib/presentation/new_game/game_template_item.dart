import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/widgets/containers/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameTemplateItem extends HookWidget {
  const GameTemplateItem({
    @required this.gameTemplate,
    @required this.onStartNewGamePressed,
    this.onContinueGamePressed,
    this.onSelectionChanged,
    this.selectedItemId,
  });

  final String selectedItemId;
  final GameTemplate gameTemplate;
  final void Function(GameTemplate) onStartNewGamePressed;
  final void Function(GameTemplate) onContinueGamePressed;
  final void Function(String) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final startGame = () {
      onStartNewGamePressed(gameTemplate);
      onSelectionChanged?.call(null);
    };

    final continueGame = () {
      onContinueGamePressed?.call(gameTemplate);
      onSelectionChanged?.call(null);
    };

    return GameCard(
      title: gameTemplate.name,
      description: gameTemplate.getDescription(),
      imageUrl: gameTemplate.image,
      startGame: startGame,
      continueGame: continueGame,
      isCollapsed: selectedItemId == gameTemplate.id,
      onTap: () {
        if (onContinueGamePressed == null) {
          startGame();
          return;
        }

        if (selectedItemId == gameTemplate.id) {
          onSelectionChanged?.call(null);
          return;
        }

        onSelectionChanged?.call(gameTemplate.id);
      },
    );
  }
}
