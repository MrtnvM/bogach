import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/services/new_game_servise.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> newGameEpic({@required NewGameService newGameService}) {
  final getMageTemplates = epic((action$, store) {
    return action$
        .whereType<GetGameTemplatesAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => newGameService
            .getGameTemplates()
            .map<Action>(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    getMageTemplates,
  ]);
}
