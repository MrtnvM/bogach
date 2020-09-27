import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/features/new_game/actions/create_new_game_action.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class TemplateGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final templatesRequestState = useGlobalState(
      (s) => s.network.getRequestState(NetworkRequest.loadGameTemplates),
    );

    final createGameRequestState = useGlobalState(
      (s) => s.network.getRequestState(NetworkRequest.createGame),
    );

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final gameActions = useGameActions();
    final dispatch = useDispatcher();
    final userId = useUserId();

    final showCreateGameErrorAlert = useWarningAlert(
      needCancelButton: true,
    );

    void Function(GameTemplate) createNewGame;
    createNewGame = (template) {
      dispatch(CreateNewGameAsyncAction(templateId: template.id))
        .then((createdGameId) {
          final gameContext = GameContext(gameId: createdGameId, userId: userId);
          dispatch(StartGameAction(cre))
        })

      gameActions.createGame(template.id).then((createdGameId) {
        gameActions.startGame(createdGameId);

        appRouter.goToRoot();
        appRouter.goTo(GameBoard());
      }).catchError(
        (e) => showCreateGameErrorAlert(e, () => createNewGame(template)),
      );
    };

    final isLoading = templatesRequestState.isInProgress ||
        createGameRequestState.isInProgress;
    return LoadableView(
      isLoading: isLoading,
      backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
      child: LoadableListView<GameTemplate>(
        viewModel: LoadableListViewModel(
          items: gameTemplates,
          itemBuilder: (i) => GameTemplateItem(
            gameTemplate: gameTemplates.items[i],
            onTemplateSelected: (template) {
              AnalyticsSender.templateSelected(template.name);
              createNewGame(template);
            },
          ),
          loadListRequestState: templatesRequestState,
          loadList: gameActions.loadGameTemplates,
          padding: const EdgeInsets.all(16),
          emptyStateWidget: EmptyWidget(),
          errorWidget: CommonErrorWidget(gameActions.loadGameTemplates),
        ),
      ),
    );
  }
}
