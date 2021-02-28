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
  });

  final Quest quest;
  final String currentGameId;
  final bool isLocked;
  final void Function(Quest, QuestAction) onQuestSelected;

  @override
  Widget build(BuildContext context) {
    final isCollapsed = useState(false);

    final startGame = () {
      onQuestSelected(quest, QuestAction.startNewGame);
      isCollapsed.value = false;
    };

    final continueGame = () {
      onQuestSelected(quest, QuestAction.continueGame);
      isCollapsed.value = false;
    };

    return GameCard(
      title: quest.name,
      description: quest.description,
      imageUrl: quest.image,
      startGame: startGame,
      continueGame: continueGame,
      isCollapsed: isCollapsed.value,
      onTap: () {
        if (isLocked) {
          onQuestSelected?.call(null, QuestAction.startNewGame);
          isCollapsed.value = true;
          return;
        }

        if (currentGameId == null) {
          onQuestSelected?.call(quest, QuestAction.startNewGame);
          isCollapsed.value = true;
          return;
        }

        isCollapsed.value = !isCollapsed.value;
      },
    );
  }
}
