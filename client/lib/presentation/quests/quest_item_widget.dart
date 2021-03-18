import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/widgets/containers/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum QuestAction { startNewGame, continueGame }

class QuestItemWidget extends HookWidget {
  const QuestItemWidget({
    @required this.quest,
    @required this.currentGameId,
    @required this.onQuestSelected,
    @required this.isLocked,
    @required this.selectedQuestId,
    @required this.onSelectionChanged,
  });

  final Quest quest;
  final String currentGameId;
  final bool isLocked;
  final void Function(Quest, QuestAction) onQuestSelected;
  final String selectedQuestId;
  final void Function(String) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final startGame = () {
      onQuestSelected(quest, QuestAction.startNewGame);
      onSelectionChanged(null);
    };

    final continueGame = () {
      onQuestSelected(quest, QuestAction.continueGame);
      onSelectionChanged(null);
    };

    return GameCard(
      title: quest.name,
      description: quest.description,
      imageUrl: quest.image,
      startGame: startGame,
      continueGame: continueGame,
      isCollapsed: selectedQuestId == quest.id,
      onTap: () {
        if (isLocked) {
          onQuestSelected?.call(null, QuestAction.startNewGame);
          onSelectionChanged(null);
          return;
        }

        if (currentGameId == null) {
          onQuestSelected?.call(quest, QuestAction.startNewGame);
          onSelectionChanged(null);
          return;
        }

        if (selectedQuestId == quest.id) {
          onSelectionChanged(null);
        } else {
          onSelectionChanged(quest.id);
        }
      },
    );
  }
}
