import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class CreateMultiplayerGamePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final requestState = useGlobalState(
      (s) => s.newGame.getGameTemplatesRequestState,
    );

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final gameAcitons = useGameActions();
    final multiplayerActions = useMultiplayerActions();

    //ignore: avoid_types_on_closure_parameters
    final onGameTempalateSelected = (GameTemplate template) {
      multiplayerActions.selectGameTemplate(template);

      multiplayerActions
          .createRoom()
          .then((_) => appRouter.goTo(RoomPage()))
          .catchError((error) {
        logger.e('ERROR: On room creation with template ID: ${template.id}');
        logger.e(error);

        // TODO(Maxim): Show detailed error
        handleError(context: context, exception: error);
      });
    };

    return Loadable(
      isLoading: requestState.isInProgress,
      backgroundColor: ColorRes.mainGreen,
      child: CashFlowScaffold(
        title: Strings.chooseLevel,
        showUser: true,
        horizontalPadding: 10,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: ColorRes.mainGreen,
              child: _buildGameTemplateList(
                gameTemplates: gameTemplates,
                onGameTempalateSelected: onGameTempalateSelected,
                loadGameTempalatesRequestState: requestState,
                loadGameTemplates: gameAcitons.loadGameTemplates,
              ),
            ),
            _buildGoBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTemplateList({
    @required StoreList<GameTemplate> gameTemplates,
    @required void onGameTempalateSelected(GameTemplate template),
    @required RefreshableRequestState loadGameTempalatesRequestState,
    @required VoidCallback loadGameTemplates,
  }) {
    return LoadableList<GameTemplate>(
      viewModel: LoadableListViewModel(
        items: gameTemplates,
        itemBuilder: (i) => GameTemplateItem(
          gameTemplate: gameTemplates.items[i],
          onTemplateSelected: onGameTempalateSelected,
        ),
        loadListRequestState: loadGameTempalatesRequestState,
        loadList: loadGameTemplates,
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildGoBackButton() {
    return Positioned(
      bottom: 16,
      child: Container(
        height: 50,
        width: 200,
        child: ColorButton(
          text: Strings.goBack,
          onPressed: appRouter.goBack,
          color: ColorRes.yellow,
        ),
      ),
    );
  }
}
