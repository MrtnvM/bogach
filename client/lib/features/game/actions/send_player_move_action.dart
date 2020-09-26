import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/game/actions/set_active_game_state.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

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
  FutureOr<AppState> reduce() {
    final gameService = GetIt.I.get<GameService>();

    final sendingEventIndex = state.game.currentGame?.currentEvents?.indexWhere(
      (e) => e.id == eventId,
    );

    if (sendingEventIndex == null || sendingEventIndex < 0) {
      // TODO(Maxim): Report error to Crashlytics

      // FirebaseCrashlytics.instance.recordError(
      //     'Game Reducer: Event with id $eventId not found', null);
      return state;
    }

    final context = state.game.currentGameContext;

    return gameService
        .sendPlayerAction(PlayerActionRequestModel(
          playerAction: playerAction,
          gameContext: context,
          eventId: eventId,
        ))
        .first
        .then((_) => state)
        .catchError(
          (_) => state.rebuild((s) {
            s.game.activeGameState = s.game.activeGameState.maybeMap(
              gameEvent: (gameEventState) => gameEventState.copyWith(
                sendingEventIndex: -1,
              ),
              orElse: () => s.game.activeGameState,
            );
          }),
        );
  }
}
