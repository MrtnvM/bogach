import 'dart:math';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> gameEpic({
  @required GameService gameService,
  @required UserService userService,
}) {
  final startGameEpic = epic((action$, store) {
    return action$.whereType<StartGameAction>() //
        .flatMap((action) {
      final game = gameService.getGame(action.gameContext);

      final userProfiles = game
          .take(1)
          .asyncMap((game) => userService.loadProfiles(game.participants))
          .map<Action>((profiles) => SetGameParticipnatsProfiles(profiles))
          .onErrorReturnWith((e) => OnGameErrorAction(e));

      final gameSubscription = game
          .flatMap<Action>((game) {
            if (!shouldOpenNewQuestForUser(game)) {
              return Stream.value(OnGameStateChangedAction(game));
            }

            final currentQuest = game.config.level;
            final quests = store.state.newGame.gameLevels.items;
            final currentQuestIndex = quests.indexWhere(
              (l) => l.id == currentQuest,
            );

            final newQuestIndex = min(currentQuestIndex + 1, quests.length - 1);

            return Stream.fromIterable([
              OnGameStateChangedAction(game),
              UpdateCurrentQuestIndexAsyncAction(newQuestIndex),
            ]);
          })
          .onErrorReturnWith((e) => OnGameErrorAction(e))
          .takeUntil(action$.whereType<StopActiveGameAction>());

      return Rx.concat([userProfiles, gameSubscription]);
    });
  });

  final sendGameEventPlayerActionEpic = epic((action$, store) {
    return action$
        .whereType<SendPlayerMoveAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) {
      final context = store.state.game.currentGameContext;
      final eventId = action.eventId;

      return gameService
          .sendPlayerAction(PlayerActionRequestModel(
            playerAction: action.playerAction,
            gameContext: context,
            eventId: eventId,
          ))
          .map(action.complete)
          .onErrorReturnWith(action.fail);
    });
  });

  final startNewMonthEpic = epic((action$, store) {
    return action$
        .whereType<StartNewMonthAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => gameService
            .startNewMonth(store.state.game.currentGameContext)
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    startGameEpic,
    sendGameEventPlayerActionEpic,
    startNewMonthEpic,
  ]);
}

bool shouldOpenNewQuestForUser(Game game) {
  final userId = game.participants.first;
  final gameLevel = game.config.level;

  final isGameCompleted = game.state.gameStatus == GameStatus.gameOver;
  final isQuestGame = gameLevel != null;
  final isUserWon = game.state.participantsProgress[userId].progress >= 1;

  return isGameCompleted && isQuestGame && isUserWon;
}
