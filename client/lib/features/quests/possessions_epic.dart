import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/quests/possessions_actions.dart';
import 'package:cash_flow/services/firebase_service.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> possessionsEpic({@required FirebaseService firebaseService}) {
  final Epic<AppState> getPossessionsEpic = (action$, store) {
    return Observable(action$)
        .whereType<ListenPossessionsStartAction>()
        .flatMap((action) => firebaseService
            .getPossessionsStates(action.gameId)
            .takeUntil(Observable(action$)
                .whereType<StopListenPossessionsStartAction>())
            .map<Action>((state) => ListenPossessionsSuccessAction(state))
            .onErrorReturnWith((e) => ListenPossessionsErrorAction()));
  };

  return combineEpics([
    getPossessionsEpic,
  ]);
}
