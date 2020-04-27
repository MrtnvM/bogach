import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> gameEpic({
  @required GameService gameService,
}) {
  final getPossessionsEpic = epic((action$, store) {
    return action$
        .whereType<StartGameAction>() //
        .flatMap((action) => gameService
            .getGameData(action.gameId)
            .takeUntil(
              action$.whereType<StopActiveGameAction>(),
            )
            .map<Action>((state) => OnGameStateChangedAction(state))
            .onErrorReturnWith((e) => OnGameErrorAction(e)));
  });

  final sendGameEventPlayerActionAction = epic((action$, store) {
    return action$
        .whereType<SendGameEventPlayerActionAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) {
      final context = store.state.gameState.currentGameContext;
      final eventId = action.eventId;

      return gameService
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
