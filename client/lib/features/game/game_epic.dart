import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/services/firebase_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> possessionsEpic({@required FirebaseService firebaseService}) {
  final getPossessionsEpic = epic((action$, store) {
    return action$
        .whereType<ListenGameStateStartAction>()
        .flatMap((action) => firebaseService
            .getGameData(action.gameId)
            .takeUntil(
              action$.whereType<StopListenGameStateAction>(),
            )
            .map<Action>((state) => ListenGameStateSuccessAction(state))
            .onErrorReturnWith((e) => ListenGameStateErrorAction()));
  });

  return combineEpics([
    getPossessionsEpic,
  ]);
}
