import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/features/game/actions/set_active_game_state.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class SendPlayerMoveAction extends BaseAction {
  SendPlayerMoveAction({
    @required this.eventId,
    this.playerAction,
  });

  final PlayerAction playerAction;
  final String eventId;

  @override
  Operation get operationKey => Operation.sendPlayerAction;

  @override
  FutureOr<void> before() async {
    final sendingEventIndex = state.game.currentGame?.currentEvents?.indexWhere(
      (e) => e.id == eventId,
    );
    final activeGameState = state.game.activeGameState;

    await dispatchFuture(SetActiveGameState(activeGameState.maybeMap(
      gameEvent: (gameEventState) => gameEventState.copyWith(
        sendingEventIndex: sendingEventIndex,
      ),
      orElse: () => activeGameState,
    )));
  }

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final sendingEventIndex = state.game.currentGame?.currentEvents?.indexWhere(
      (e) => e.id == eventId,
    );

    if (sendingEventIndex == null || sendingEventIndex < 0) {
      FirebaseCrashlytics.instance.recordError(
        'Game Reducer: Event with id $eventId not found',
        null,
      );

      return state;
    }

    final context = state.game.currentGameContext;
    final requestModel = PlayerActionRequestModel(
      playerAction: playerAction,
      gameContext: context,
      eventId: eventId,
    );

    await gameService.sendPlayerAction(requestModel).catchError((error) {
      final activeGameState = state.game.activeGameState.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(
          sendingEventIndex: -1,
        ),
        orElse: () => state.game.activeGameState,
      );

      dispatch(SetActiveGameState(activeGameState));

      throw error;
    });

    return null;
  }
}
