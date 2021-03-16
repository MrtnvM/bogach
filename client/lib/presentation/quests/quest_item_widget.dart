import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/presentation/main/models/selected_item_view_model.dart';
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
    @required this.selectedListsItem,
  });

  final Quest quest;
  final String currentGameId;
  final bool isLocked;
  final void Function(Quest, QuestAction) onQuestSelected;
  final ValueNotifier<SelectedItemViewModel> selectedListsItem;

  @override
  Widget build(BuildContext context) {
    final startGame = () {
      onQuestSelected(quest, QuestAction.startNewGame);
      selectedListsItem.value = SelectedItemViewModel();
    };

    final continueGame = () {
      onQuestSelected(quest, QuestAction.continueGame);
      selectedListsItem.value = SelectedItemViewModel();
    };

    return GameCard(
      title: quest.name,
      description: quest.description,
      imageUrl: quest.image,
      startGame: startGame,
      continueGame: continueGame,
      isCollapsed: selectedListsItem.value.selectedQuest == quest.id,
      onTap: () {
        if (isLocked) {
          onQuestSelected?.call(null, QuestAction.startNewGame);
          selectedListsItem.value = SelectedItemViewModel();
          return;
        }

        if (currentGameId == null) {
          onQuestSelected?.call(quest, QuestAction.startNewGame);
          selectedListsItem.value = SelectedItemViewModel();
          return;
        }

        if (selectedListsItem.value.selectedQuest == quest.id) {
          selectedListsItem.value = SelectedItemViewModel();
        } else {
          selectedListsItem.value =
              SelectedItemViewModel(selectedQuest: quest.id);
        }
      },
    );
  }
}
