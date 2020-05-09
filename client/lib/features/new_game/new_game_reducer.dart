import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/features/new_game/new_game_state.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final newGameReducer = Reducer<NewGameState>()
  ..on<GetGameTemplatesAsyncAction>(
    (state, action) => state.rebuild((s) => action
      ..onStart(() {
        return s.getGameTemplatesRequestState =
            RefreshableRequestState.inProgress;
      })
      ..onSuccess((gameTemplates) {
        return s
          ..getGameTemplatesRequestState = RefreshableRequestState.success
          ..gameTemplates = StoreList<GameTemplate>(gameTemplates);
      })
      ..onError((_) {
        return s.getGameTemplatesRequestState = RefreshableRequestState.error;
      })),
  )
  ..on<CreateNewGameAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.createNewGameRequestState = action.requestState;

      action..onSuccess((newGameId) => s.newGameId = newGameId);
    }),
  );
