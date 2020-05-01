import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/features/new_game/new_game_state.dart';
import 'package:cash_flow/models/domain/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/game_board.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class TemplateGameList extends StatelessWidget with ReduxComponent {
  @override
  Widget build(BuildContext context) {
    return AppStateConnector<NewGameState>(
      converter: (state) => state.newGameState,
      builder: (context, state) => Loadable(
        isLoading: state.createNewGameRequestState.isInProgress,
        backgroundColor: ColorRes.mainGreen,
        child: LoadableList<GameTemplate>(
          viewModel: LoadableListViewModel(
            items: state.gameTemplates,
            itemBuilder: (i) => _buildListItem(state.gameTemplates.items[i]),
            loadListRequestState: state.getGameTemplatesRequestState,
            loadList: () => dispatchAsyncAction(GetGameTemplatesAsyncAction()),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(GameTemplate item) {
    return TemplateGameItem(
      game: item,
      onGamePressed: _createNewGame,
    );
  }

  void _createNewGame(GameTemplate game) {
    dispatchAsyncAction(CreateNewGameAsyncAction(templateId: game.id))
        .listen((action) => action
          ..onSuccess(_openGameScreen)
          ..onError(_openGameScreen));
  }

  void _openGameScreen(_) {
    appRouter.startWith(GameBoard());
  }
}
