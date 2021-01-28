import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/features/new_game/actions/start_singleplayer_game_action.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TemplateGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final templatesRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.loadGameTemplates),
    );

    final createGameRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.createGame),
    );

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);
    final dispatch = useDispatcher();

    void Function(GameTemplate) createNewGame;
    createNewGame = (template) {
      AnalyticsSender.singleplayerTemplateSelected(template.name);

      dispatch(StartSinglePlayerGameAction(templateId: template.id))
          .then((_) => isTutorialPassed
              ? appRouter.goTo(const GameBoard())
              : appRouter.goTo(const TutorialPage()))
          .catchError(
            (e) => handleError(
              context: context,
              exception: e,
              onRetry: () => createNewGame(template),
            ),
          );
    };

    final isLoading = templatesRequestState.isInProgress ||
        createGameRequestState.isInProgress;

    final loadGameTemplates = () => dispatch(GetGameTemplatesAction());

    final userId = useUserId();
    final user = useCurrentUser();

    // ignore: avoid_types_on_closure_parameters
    final getLastGameIndex = (GameTemplate template) {
      final games = user.lastGames.singleplayerGames;
      final index = games.indexWhere((g) => g.templateId == template.id);
      return index;
    };

    final void Function(GameTemplate) goToGame = (template) {
      final index = getLastGameIndex(template);
      if (index < 0) {
        return;
      }

      AnalyticsSender.singleplayerTemplateSelected(template.name);
      AnalyticsSender.singleplayerContinueGame();

      final gameId = user.lastGames.singleplayerGames[index].gameId;
      final gameContext = GameContext(gameId: gameId, userId: userId);
      dispatch(StartGameAction(gameContext));
      appRouter.goTo(const GameBoard());
    };

    final mediaQueryData = useAdaptiveMediaQueryData();

    return MediaQuery(
      data: mediaQueryData,
      child: LoadableView(
        isLoading: isLoading,
        backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
        child: LoadableListView<GameTemplate>(
          viewModel: LoadableListViewModel(
            items: gameTemplates,
            itemBuilder: (i) => GameTemplateItem(
              gameTemplate: gameTemplates.items[i],
              onStartNewGamePressed: createNewGame,
              onContinueGamePressed:
                  getLastGameIndex(gameTemplates.items[i]) >= 0
                      ? goToGame
                      : null,
            ),
            loadListRequestState: templatesRequestState,
            loadList: loadGameTemplates,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            emptyStateWidget: EmptyWidget(),
            errorWidget: CommonErrorWidget(loadGameTemplates),
          ),
        ),
      ),
    );
  }
}
