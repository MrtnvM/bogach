import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
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
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class CreateMultiplayerGamePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final createRoomRequestState =
        useGlobalState((s) => s.multiplayer.createRoomRequestState);
    final getGameTemplatesRequestState =
        useGlobalState((s) => s.newGame.getGameTemplatesRequestState);

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
        Logger.e('ERROR: On room creation with template ID: ${template.id}');
        Logger.e(error);

        // TODO(Maxim): Show detailed error
        handleError(context: context, exception: error);
      });
    };

    return Loadable(
      isLoading: createRoomRequestState.isInProgress,
      backgroundColor: ColorRes.black80,
      child: CashFlowScaffold(
        title: Strings.chooseLevel,
        showUser: true,
        horizontalPadding: 10,
        showBackArrow: true,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: ColorRes.mainGreen,
              child: _buildGameTemplateList(
                gameTemplates: gameTemplates,
                onGameTempalateSelected: onGameTempalateSelected,
                loadGameTempalatesRequestState: getGameTemplatesRequestState,
                loadGameTemplates: gameAcitons.loadGameTemplates,
              ),
            ),
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
          onTemplateSelected: (template) {
            onGameTempalateSelected(template);
            AnalyticsSender.templateSelected(template.name);
          },
        ),
        loadListRequestState: loadGameTempalatesRequestState,
        loadList: loadGameTemplates,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
