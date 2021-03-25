import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/features/new_game/actions/start_singleplayer_game_action.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

_GameTemplateListViewModel useGameTemplateListViewModel() {
  final context = useContext();
  final templatesRequestState = useGlobalState(
    (s) => s.getOperationState(Operation.loadGameTemplates),
  );

  final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
  final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);
  final dispatch = useDispatcher();

  void Function(GameTemplate) createNewGame;
  createNewGame = (template) {
    AnalyticsSender.singleplayerTemplateSelected(template.name);

    dispatch(StartSinglePlayerGameAction(templateId: template.id)).then((_) {
      final gameId = StoreProvider.state<AppState>(context).newGame.newGameId;

      if (isTutorialPassed) {
        appRouter.goTo(GameBoard(gameId: gameId));
      } else {
        appRouter.goTo(const TutorialPage());
      }
    }).catchError(
      (e) => handleError(
        context: context,
        exception: e,
        onRetry: () => createNewGame(template),
      ),
    );
  };

  final loadGameTemplates = () => dispatch(GetGameTemplatesAction());

  final userId = useUserId();
  final user = useCurrentUser();

  // ignore: avoid_types_on_closure_parameters
  final canContinueGame = (GameTemplate template) {
    final games = user.lastGames.singleplayerGames;
    final index = games.indexWhere((g) => g.templateId == template.id);
    final hasSuchGame = index >= 0;
    return hasSuchGame;
  };

  final void Function(GameTemplate) continueGame = (template) {
    if (!canContinueGame(template)) {
      return;
    }

    final games = user.lastGames.singleplayerGames;
    final index = games.indexWhere((g) => g.templateId == template.id);

    AnalyticsSender.singleplayerTemplateSelected(template.name);
    AnalyticsSender.singleplayerContinueGame();

    final gameId = user.lastGames.singleplayerGames[index].gameId;
    final gameContext = GameContext(gameId: gameId, userId: userId);
    dispatch(StartGameAction(gameContext));
    appRouter.goTo(GameBoard(gameId: gameContext.gameId));
  };

  return _GameTemplateListViewModel(
    gameTemplates: gameTemplates,
    templatesRequestState: templatesRequestState,
    loadGameTemplates: loadGameTemplates,
    createNewGame: createNewGame,
    continueGame: continueGame,
    canContinueGame: canContinueGame,
  );
}

class _GameTemplateListViewModel {
  _GameTemplateListViewModel({
    @required this.templatesRequestState,
    @required this.gameTemplates,
    @required this.createNewGame,
    @required this.continueGame,
    @required this.loadGameTemplates,
    @required this.canContinueGame,
  });

  final OperationState templatesRequestState;
  final StoreList<GameTemplate> gameTemplates;
  final void Function(GameTemplate) createNewGame;
  final void Function(GameTemplate) continueGame;
  final VoidCallback loadGameTemplates;
  final bool Function(GameTemplate) canContinueGame;
}
