import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/services/firebase_service.dart';
import 'package:cash_flow/services/game_event_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> gameEpic({
  @required FirebaseService firebaseService,
  @required GameEventService gameEventService,
}) {
  final getPossessionsEpic = epic((action$, store) {
    return action$
        .whereType<StartGameAction>()
        .flatMap((action) => firebaseService
                .getGameData(action.gameId)
                .takeUntil(
                  action$.whereType<StopActiveGameAction>(),
                )
                .map<Action>((state) => OnGameStateChangedAction(state))
                .onErrorReturnWith((e) {
              print(e);
              return OnGameErrorAction(e);
            }));
  });

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
    getPossessionsEpic,
    sendGameEventPlayerActionAction,
  ]);
}
