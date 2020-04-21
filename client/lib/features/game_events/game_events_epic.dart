import 'package:flutter/foundation.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/game_events/game_events_actions.dart';
import 'package:cash_flow/services/game_event_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> gameEventsEpic({@required GameEventService gameEventService}) {
  final sendGameEventPlayerActionAction = epic((action$, store) {
    return action$
        .whereType<SendGameEventPlayerActionAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) {
      final context = store.state.gameState.currentGameContext;
      final eventId = action.eventId;

      return gameEventService
          .sendPlayerAction(
            action: action.action,
            context: context,
            eventId: eventId,
          )
          .map(action.complete)
          .onErrorReturnWith(action.fail);
    });
  });

  return combineEpics([
    sendGameEventPlayerActionAction,
  ]);
}
