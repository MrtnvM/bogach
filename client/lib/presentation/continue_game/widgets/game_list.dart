import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/features/new_game/new_game_state.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/user/current_user.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/game_board.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:cash_flow/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class TemplateGameList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TemplateGameListState();
}

class TemplateGameListState extends State<TemplateGameList>
    with ReduxComponent {
  @override
  Widget build(BuildContext context) {
    return AppStateConnector<Tuple<NewGameState, CurrentUser>>(
      converter: (state) => Tuple(
        state.newGameState,
        state.login.currentUser,
      ),
      builder: (context, state) => _buildTemplateList(
        gameState: state.item1,
        user: state.item2,
      ),
    );
  }

  Widget _buildTemplateList({NewGameState gameState, CurrentUser user}) {
    return Loadable(
      isLoading: gameState.createNewGameRequestState.isInProgress,
      backgroundColor: ColorRes.mainGreen,
      child: LoadableList<GameTemplate>(
        viewModel: LoadableListViewModel(
          items: gameState.gameTemplates,
          itemBuilder: (i) => _buildListItem(
            gameState.gameTemplates.items[i],
            user,
          ),
          loadListRequestState: gameState.getGameTemplatesRequestState,
          loadList: () => dispatchAsyncAction(GetGameTemplatesAsyncAction()),
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildListItem(GameTemplate item, CurrentUser user) {
    return GameTemplateItem(
      gameTemplate: item,
      onTemplateSelected: (template) => _createNewGame(template, user),
    );
  }

  void _createNewGame(GameTemplate template, CurrentUser user) {
    dispatchAsyncAction(CreateNewGameAsyncAction(templateId: template.id))
        .listen((action) => action
          ..onSuccess((createdGameId) => _openGameScreen(createdGameId, user))
          ..onError((e) => _showAlertErrorNewGame(e, template, user)));
  }

  void _openGameScreen(String gameId, CurrentUser user) {
    final gameContext = GameContext(gameId: gameId, userId: user.userId);

    appRouter.goToRoot();
    appRouter.goTo(GameBoard(gameContext: gameContext));
  }

  void _showAlertErrorNewGame(
    dynamic e,
    GameTemplate gameTemplate,
    CurrentUser user,
  ) {
    showWarningAlertDialog(
      context: context,
      errorMessage: e.toString(),
      needCancelButton: true,
      onSubmit: () => _createNewGame(gameTemplate, user),
    );
  }
}
