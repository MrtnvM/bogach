import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class TemplateGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final requestState = useGlobalState(
      (s) => s.newGame.getGameTemplatesRequestState,
    );

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final gameActions = useGameActions();

    final showCreateGameErrorAlert = useWarningAlert(
      needCancelButton: true,
    );

    void Function(GameTemplate) createNewGame;
    createNewGame = (template) {
      gameActions.createGame(template.id).then((createdGameId) {
        gameActions.startGame(createdGameId);

        appRouter.goToRoot();
        appRouter.goTo(GameBoard());
      }).catchError(
        (e) => showCreateGameErrorAlert(e, () => createNewGame(template)),
      );
    };

    return Loadable(
      isLoading: requestState.isInProgress,
      backgroundColor: ColorRes.mainGreen,
      child: LoadableList<GameTemplate>(
        viewModel: LoadableListViewModel(
          items: gameTemplates,
          itemBuilder: (i) => GameTemplateItem(
            gameTemplate: gameTemplates.items[i],
            onTemplateSelected: createNewGame,
          ),
          loadListRequestState: requestState,
          loadList: gameActions.loadGameTemplates,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
