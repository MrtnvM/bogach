import 'dart:async';
import 'dart:math';

import 'package:cash_flow/features/game/actions/on_game_error.dart';
import 'package:cash_flow/features/game/actions/set_game_participants_profiles_action.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/game/actions/on_game_state_changed_action.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';

class StartGameAction extends BaseAction {
  StartGameAction(this.gameContext) : assert(gameContext != null);

  final GameContext gameContext;

  @override
  FutureOr<AppState> reduce() {
    final gameService = GetIt.I.get<GameService>();
    final userService = GetIt.I.get<UserService>();

    final onStopActiveGame =
        ReduxActionObserver.instance.onAction.whereType<StopActiveGameAction>();

    final userProfiles = gameService
        .getGame(gameContext)
        .take(1)
        .asyncMap((game) => userService.loadProfiles(game.participants))
        .map<BaseAction>(
          (profiles) => SetGameParticipantsProfilesAction(profiles),
        )
        .onErrorReturnWith((e) => OnGameErrorAction(e));

    final gameSubscription = gameService
        .getGame(gameContext)
        .flatMap<BaseAction>((game) {
          if (!_shouldOpenNewQuestForUser(game)) {
            return Stream.value(OnGameStateChangedAction(game));
          }

          final currentQuest = game.config.level;
          final quests = state.newGame.gameLevels.items;
          final currentQuestIndex = quests.indexWhere(
            (l) => l.id == currentQuest,
          );

          final newQuestIndex = min(currentQuestIndex + 1, quests.length - 1);

          return Stream<BaseAction>.fromIterable([
            OnGameStateChangedAction(game),
            UpdateCurrentQuestIndexAsyncAction(newQuestIndex),
          ]);
        })
        .onErrorReturnWith((e) => OnGameErrorAction(e))
        .takeUntil(onStopActiveGame);

    Rx.concat([userProfiles, gameSubscription])
        .takeUntil(onStopActiveGame)
        .listen(dispatch);

    return state.rebuild(
      (s) => s.game.activeGameState = ActiveGameState.waitingForStart(),
    );
  }

  @override
  String toString() {
    return '${super.toString()} $gameContext';
  }
}

class StopActiveGameAction extends BaseAction {
  @override
  AppState reduce() => null;
}

bool _shouldOpenNewQuestForUser(Game game) {
  final userId = game.participants.first;
  final gameLevel = game.config.level;

  final isGameCompleted = game.state.gameStatus == GameStatus.gameOver;
  final isQuestGame = gameLevel != null;
  final isUserWon = game.state.participantsProgress[userId].progress >= 1;

  return isGameCompleted && isQuestGame && isUserWon;
}
