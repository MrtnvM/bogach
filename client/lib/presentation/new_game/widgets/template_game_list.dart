import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/dispatch_hook.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/game_board.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class TemplateGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final requestState = useGlobalState(
      (s) => s.newGameState.getGameTemplatesRequestState,
    );

    final gameTemplates = useGlobalState((s) => s.newGameState.gameTemplates);
    final userId = useUserId();

    final actionRunner = useActionRunner();

    final showCreateGameErrorAlert = useWarningAlert(
      needCancelButton: true,
    );

    void Function(GameTemplate) createNewGame;
    createNewGame = (template) {
      final action = CreateNewGameAsyncAction(templateId: template.id);

      actionRunner
          .runAsyncAction(action)
          .then((createdGameId) => _openGameScreen(createdGameId, userId))
          .catchError(
            (e) => showCreateGameErrorAlert(e, () => createNewGame(template)),
          );
    };

    final loadGameTemplates = () {
      actionRunner.runAction(GetGameTemplatesAsyncAction());
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
          loadList: loadGameTemplates,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  void _openGameScreen(String gameId, String userId) {
    final gameContext = GameContext(gameId: gameId, userId: userId);

    appRouter.goToRoot();
    appRouter.goTo(GameBoard(gameContext: gameContext));
  }
}
