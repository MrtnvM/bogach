import 'dart:async';
import 'dart:math';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

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
        .map<BaseAction>((profiles) => SetGameParticipantsProfiles(profiles))
        .onErrorReturnWith((e) => OnGameErrorAction(e));

    final gameSubscription = gameService
        .getGame(gameContext)
        .flatMap<BaseAction>((game) {
          if (!shouldOpenNewQuestForUser(game)) {
            return Stream.value(OnGameStateChangedAction(game));
          }

          final currentQuest = game.config.level;
          final quests = store.state.newGame.gameLevels.items;
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

    Rx.concat([userProfiles, gameSubscription]).listen((action) {
      dispatch(action);
    });

    return state.rebuild(
      (s) => s.game
        ..getRequestState = RequestState.inProgress
        ..activeGameState = ActiveGameState.waitingForStart(),
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

class OnGameStateChangedAction extends BaseAction {
  OnGameStateChangedAction(this.game);

  final Game game;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      var newActiveGameState = s.game.activeGameState;

      if (game.state.gameStatus == GameStatus.playersMove) {
        final userId = s.game.currentGameContext.userId;
        final progress = game.state.participantsProgress[userId];
        if (progress.status == ParticipantProgressStatus.monthResult) {
          final waitingPlayerList = getParticipantIdsForWaiting(
            userId,
            game.state.participantsProgress,
          );

          newActiveGameState = waitingPlayerList.isEmpty
              ? ActiveGameState.monthResult()
              : ActiveGameState.waitingPlayers(waitingPlayerList);
        }

        if (progress.status == ParticipantProgressStatus.playerMove) {
          newActiveGameState = s.game.activeGameState.maybeWhen(
            gameEvent: (eventIndex, sendingEventIndex) {
              return ActiveGameState.gameEvent(
                eventIndex: progress.currentEventIndex,
                sendingEventIndex: sendingEventIndex,
              );
            },
            orElse: () => ActiveGameState.gameEvent(
              eventIndex: progress.currentEventIndex,
              sendingEventIndex: -1,
            ),
          );
        }
      }

      if (game.state.gameStatus == GameStatus.gameOver) {
        newActiveGameState = ActiveGameState.gameOver(
          winners: game.state.winners,
          monthNumber: game.state.monthNumber,
        );
      }

      return s.game
        ..getRequestState = RequestState.success
        ..currentGame = game
        ..activeGameState = newActiveGameState;
    });
  }
}

class OnGameErrorAction extends BaseAction {
  OnGameErrorAction(this.error);

  final dynamic error;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      s.game.getRequestState = RequestState.error;

      s.game.activeGameState = s.game.activeGameState.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(
          sendingEventIndex: -1,
        ),
        orElse: () => s.game.activeGameState,
      );
    });
  }

  @override
  String toString() {
    return '${super.toString()}' '\n$error';
  }
}

class SetGameContextAction extends Action {
  SetGameContextAction(this.gameContext);

  final GameContext gameContext;

  @override
  FutureOr reduce() {
    return state.rebuild(
      (s) => s.currentGameContext = gameContext,
    );
  }
}

class SendPlayerMoveAsyncAction extends BaseAction {
  SendPlayerMoveAsyncAction({
    @required this.eventId,
    this.playerAction,
  });

  final PlayerAction playerAction;
  final String eventId;

  @override
  FutureOr<void> before() {
    final sendingEventIndex = state.game.currentGame?.currentEvents?.indexWhere(
      (e) => e.id == eventId,
    );
    final activeGameState = state.game.activeGameState;

    dispatch(SetActiveGameState(activeGameState.maybeMap(
      gameEvent: (gameEventState) => gameEventState.copyWith(
        sendingEventIndex: sendingEventIndex,
      ),
      orElse: () => activeGameState,
    )));

    return super.before();
  }

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    return state.rebuild((s) async {
      final sendingEventIndex = s.game.currentGame?.currentEvents?.indexWhere(
        (e) => e.id == eventId,
      );

      if (sendingEventIndex == null || sendingEventIndex < 0) {
        // TODO(Maxim): Report error to Crashlytics

        // FirebaseCrashlytics.instance.recordError(
        //     'Game Reducer: Event with id $eventId not found', null);
        return state;
      }

      final context = state.game.currentGameContext;

      try {
        await gameService
            .sendPlayerAction(PlayerActionRequestModel(
              playerAction: playerAction,
              gameContext: context,
              eventId: eventId,
            ))
            .first;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        s.game.activeGameState = s.game.activeGameState.maybeMap(
          gameEvent: (gameEventState) => gameEventState.copyWith(
            sendingEventIndex: -1,
          ),
          orElse: () => s.game.activeGameState,
        );
      }
    });
  }
}

class SetActiveGameState extends BaseAction {
  SetActiveGameState(this.activeGameState);

  final ActiveGameState activeGameState;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) => s.game.activeGameState = activeGameState);
  }
}

class StartNewMonthAsyncAction extends BaseAction {
  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    dispatch(SetStartNewMonthRequestStateAction(RequestState.inProgress));

    try {
      await gameService
          .startNewMonth(store.state.game.currentGameContext)
          .first;

      dispatch(SetStartNewMonthRequestStateAction(RequestState.success));
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      dispatch(SetStartNewMonthRequestStateAction(RequestState.error));
    }

    return null;
  }
}

class SetStartNewMonthRequestStateAction extends BaseAction {
  SetStartNewMonthRequestStateAction(this.requestState);

  final RequestState requestState;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild(
      (s) => s.game.startNewMonthRequestState = requestState,
    );
  }
}

class SetGameParticipantsProfiles extends BaseAction {
  SetGameParticipantsProfiles(this.userProfiles) : assert(userProfiles != null);

  final List<UserProfile> userProfiles;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      s.game.participantProfiles = StoreList<UserProfile>(userProfiles);
    });
  }
}

bool shouldOpenNewQuestForUser(Game game) {
  final userId = game.participants.first;
  final gameLevel = game.config.level;

  final isGameCompleted = game.state.gameStatus == GameStatus.gameOver;
  final isQuestGame = gameLevel != null;
  final isUserWon = game.state.participantsProgress[userId].progress >= 1;

  return isGameCompleted && isQuestGame && isUserWon;
}

List<String> getParticipantIdsForWaiting(
  String myUserId,
  Map<String, ParticipantProgress> participantsProgress,
) {
  final progress = participantsProgress[myUserId];
  final myCurrentMonth = progress.currentMonthForParticipant;

  final waitingPlayerList = participantsProgress.entries
      .where((entry) => entry.key != myUserId)
      .where((entry) {
        final progress = entry.value;
        final participantMonth = progress.currentMonthForParticipant;

        final isMoving = participantMonth == myCurrentMonth &&
            progress.status != ParticipantProgressStatus.monthResult;

        final didNotStartNewMonth =
            progress.currentMonthForParticipant < myCurrentMonth;

        return isMoving || didNotStartNewMonth;
      })
      .map((entry) => entry.key)
      .toList();

  return waitingPlayerList;
}
