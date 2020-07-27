import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> newGameEpic({@required GameService gameService}) {
  final getGameTemplatesEpic = epic((action$, store) {
    return action$
        .whereType<GetGameTemplatesAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap(
          (action) => gameService
              .getGameTemplates()
              .map(action.complete)
              .onErrorReturnWith(action.fail),
        );
  });

  final createNewGameEpic = epic((action$, store) {
    return action$
        .whereType<CreateNewGameAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap(
          (action) => gameService
              .createNewGame(
                templateId: action.templateId,
                userId: store.state.login.currentUser.userId,
              )
              .map(action.complete)
              .onErrorReturnWith(action.fail),
        );
  });

  final createNewGameByLevelEpic = epic((action$, store) {
    return action$
        .whereType<CreateNewGameByLevelAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap(
          (action) => gameService
              .createNewGameByLevel(
                gameLevelId: action.gameLevelId,
                userId: store.state.login.currentUser.userId,
              )
              .map(action.complete)
              .onErrorReturnWith(action.fail),
        );
  });

  final getUserGamesEpic = epic((action$, store) {
    return action$
        .whereType<GetUserGamesAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap(
          (action) => gameService
              .getUserGames(action.userId)
              .asStream()
              .map(action.complete)
              .onErrorReturnWith(action.fail),
        );
  });

  final getGameLevelsEpic = epic((action$, store) {
    return action$
        .whereType<GetGameLevelsAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap(
          (action) => gameService
              .getGameLevels()
              .map(action.complete)
              .onErrorReturnWith(action.fail),
        );
  });

  return combineEpics([
    getGameTemplatesEpic,
    createNewGameEpic,
    createNewGameByLevelEpic,
    getUserGamesEpic,
    getGameLevelsEpic,
  ]);
}
