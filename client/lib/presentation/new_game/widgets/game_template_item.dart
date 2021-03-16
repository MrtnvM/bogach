import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/presentation/main/models/selected_item_view_model.dart';
import 'package:cash_flow/widgets/containers/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameTemplateItem extends HookWidget {
  const GameTemplateItem.singleplayer({
    @required this.gameTemplate,
    @required this.onStartNewGamePressed,
    @required this.onContinueGamePressed,
    this.selectedListsItem,
  }) : templateType = _TemplateType.singleplayer;

  const GameTemplateItem.multiplayer({
    @required this.gameTemplate,
    @required this.onStartNewGamePressed,
    this.onContinueGamePressed,
    this.selectedListsItem,
  }) : templateType = _TemplateType.multiplayer;

  final GameTemplate gameTemplate;
  final void Function(GameTemplate) onStartNewGamePressed;
  final void Function(GameTemplate) onContinueGamePressed;
  final ValueNotifier<SelectedItemViewModel> selectedListsItem;
  final _TemplateType templateType;

  @override
  Widget build(BuildContext context) {
    final startGame = () {
      onStartNewGamePressed(gameTemplate);
      selectedListsItem.value = SelectedItemViewModel();
    };

    final continueGame = () {
      onContinueGamePressed(gameTemplate);
      selectedListsItem.value = SelectedItemViewModel();
    };

    return GameCard(
      title: gameTemplate.name,
      description: gameTemplate.getDescription(),
      imageUrl: gameTemplate.image,
      startGame: startGame,
      continueGame: continueGame,
      isCollapsed: _getSelectedTemplateId(selectedListsItem) == gameTemplate.id,
      onTap: () {
        if (continueGame == null) {
          startGame();
          selectedListsItem.value = SelectedItemViewModel();
        } else {
          if (_getSelectedTemplateId(selectedListsItem) == gameTemplate.id) {
            selectedListsItem.value = SelectedItemViewModel();
          } else {
            selectedListsItem.value = SelectedItemViewModel(
              selectedSingleplayerGame:
                  templateType == _TemplateType.singleplayer
                      ? gameTemplate.id
                      : '',
              selectedMultiplayerGame: templateType == _TemplateType.multiplayer
                  ? gameTemplate.id
                  : '',
            );
          }
        }
      },
    );
  }

  String _getSelectedTemplateId(
    ValueNotifier<SelectedItemViewModel> selectedListsItem,
  ) {
    switch (templateType) {
      case _TemplateType.multiplayer:
        return selectedListsItem.value.selectedMultiplayerGame;
      case _TemplateType.singleplayer:
        return selectedListsItem.value.selectedSingleplayerGame;
    }

    return '';
  }
}

enum _TemplateType {
  singleplayer,
  multiplayer,
}
