import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/features/new_game/new_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

final newGameReducer = Reducer<NewGameState>()
  ..on<GetGameTemplatesAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.getGameTemplatesRequestState = action.mapToRefreshableRequestState(
        isRefreshing: action.isRefreshing,
      );

      action.onSuccess(
        (gameTemplates) => s
          ..getGameTemplatesRequestState = RefreshableRequestState.success
          ..gameTemplates = StoreList<GameTemplate>(gameTemplates),
      );
    }),
  )
  ..on<CreateNewGameAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.createNewGameRequestState = action.requestState;

      action.onSuccess((newGameId) => s.newGameId = newGameId);
    }),
  )
  ..on<GetUserGamesAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.getUserGamesRequestState = action.mapToRefreshableRequestState(
        isRefreshing: action.isRefreshing,
      );

      action.onSuccess((games) => s.userGames = StoreList<Game>(games));
    }),
  )
  ..on<GetGameLevelsAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.getGameLevelsRequestState = action.mapToRefreshableRequestState(
        isRefreshing: action.isRefreshing,
      );

      action.onSuccess((gameLevels) => s.gameLevels.updateList(gameLevels));
    }),
  )
  ..on<CreateNewGameByLevelAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.createNewGameByLevelRequestState = action.requestState;

      action.onSuccess((newGameId) => s.newGameId = newGameId);
    }),
  );
