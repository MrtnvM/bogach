import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/features/new_game/actions/get_user_games_action.dart';
import 'package:cash_flow/features/new_game/actions/start_singleplayer_game_action.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game/type/game_type.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
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
    final dispatch = useDispatcher();

    void Function(GameTemplate) createNewGame;
    createNewGame = (template) {
      dispatch(StartSinglePlayerGameAction(templateId: template.id)).then((_) {
        appRouter.goTo(GameBoard());
      }).catchError(
        (e) => handleError(
          context: context,
          exception: e,
          onRetry: () => createNewGame(template),
        ),
      );
    };
    final getUserGamesRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.getUserGames),
    );

    final isLoading = templatesRequestState.isInProgress ||
        createGameRequestState.isInProgress ||
        getUserGamesRequestState.isInProgress;

    final loadGameTemplates = () => dispatch(GetGameTemplatesAction());

    final userId = useUserId();
    final userGames = useGlobalState((s) {
      final games = s.newGame.userGames.items
          .where((game) =>
              game.type == GameType.singleplayer() &&
              game?.config?.gameTemplateId != null &&
              game.state.gameStatus != GameStatus.gameOver)
          .toList();

      games.sort((game1, game2) => game2.id.compareTo(game1.id));

      return Map<String, Game>.fromIterable(
        games,
        key: (item) => item.config?.gameTemplateId,
      );
    });

    useEffect(() {
      dispatch(GetUserGamesAction(userId: userId));
      return null;
    }, []);

    final void Function(GameTemplate) goToGame = (template) {
      final gameId = userGames[template.id].id;
      final gameContext = GameContext(gameId: gameId, userId: userId);
      dispatch(StartGameAction(gameContext));
      appRouter.goTo(GameBoard());
    };

    return LoadableView(
      isLoading: isLoading,
      backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
      child: LoadableListView<GameTemplate>(
        viewModel: LoadableListViewModel(
          items: gameTemplates,
          itemBuilder: (i) => GameTemplateItem(
              gameTemplate: gameTemplates.items[i],
              onStartNewGamePressed: (template) {
                AnalyticsSender.templateSelected(template.name);
                createNewGame(template);
              },
              onContinueGamePressed:
                  userGames[gameTemplates.items[i].id] != null
                      ? goToGame
                      : null),
          loadListRequestState: templatesRequestState,
          loadList: loadGameTemplates,
          padding: const EdgeInsets.all(16),
          emptyStateWidget: EmptyWidget(),
          errorWidget: CommonErrorWidget(loadGameTemplates),
        ),
      ),
    );
  }
}
