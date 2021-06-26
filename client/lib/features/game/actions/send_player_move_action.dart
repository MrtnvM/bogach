import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/features/game/actions/set_active_game_state.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';

class SendPlayerMoveAction extends BaseAction {
  SendPlayerMoveAction({
    required this.gameContext,
    required this.eventId,
    this.playerAction,
  });

  final GameContext gameContext;
  final PlayerAction? playerAction;
  final String? eventId;

  @override
  Operation get operationKey => Operation.sendPlayerAction;

  @override
  Future<void> before() async {
    final gameId = gameContext.gameId;
    final game = state.game.games[gameId];

    final sendingEventIndex = game!.currentEvents.indexWhere(
      (e) => e.id == eventId,
    );
    final activeGameState = state.game.activeGameStates[gameId]!;

    final newActiveGameState = activeGameState.maybeMap(
      gameEvent: (gameEventState) => gameEventState.copyWith(
        sendingEventIndex: sendingEventIndex,
      ),
      orElse: () => activeGameState,
    );

    await dispatchFuture(SetActiveGameState(gameContext, newActiveGameState));
  }

  @override
  Future<AppState?> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final gameId = gameContext.gameId;
    final game = state.game.games[gameId];
    final sendingEventIndex = game?.currentEvents.indexWhere(
      (e) => e.id == eventId,
    );

    if (sendingEventIndex == null || sendingEventIndex < 0) {
      FirebaseCrashlytics.instance.recordError(
        'Game Reducer: Event with id $eventId not found',
        null,
      );

      return state;
    }

    final requestModel = PlayerActionRequestModel(
      playerAction: playerAction,
      gameContext: gameContext,
      eventId: eventId,
    );

    final currentActiveGameState = state.game.activeGameStates[gameId];

    await gameService.sendPlayerAction(requestModel).onError((error, st) {
      final activeGameState = currentActiveGameState!.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(
          sendingEventIndex: -1,
        ),
        orElse: () => currentActiveGameState,
      );

      dispatch(SetActiveGameState(gameContext, activeGameState));

      return Future.error(error!);
    });

    return null;
  }
}
