import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/multiplayer/actions/create_room_action.dart';
import 'package:cash_flow/features/multiplayer/actions/select_multiplayer_game_template_action.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/presentation/purchases/games_access_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';

class CreateMultiplayerGamePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final createRoomRequestState = useGlobalState((s) {
      return s.getOperationState(Operation.createRoom);
    });

    final getGameTemplatesRequestState = useGlobalState((s) {
      return s.getOperationState(Operation.loadGameTemplates);
    });

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final dispatch = useDispatcher();
    final multiplayerGamesCount =
        useGlobalState((s) => s.profile.currentUser.multiplayerGamesCount);

    final Function(GameTemplate) onGameTempalateSelected = (template) async {
      await dispatch(SelectMultiplayerGameTemplateAction(template));

      dispatch(CreateRoomAction())
          .then((_) => appRouter.goTo(RoomPage()))
          .catchError((error) {
        Logger.e('ERROR: On room creation with template ID: ${template.id}');
        Logger.e(error);

        // TODO(Maxim): Show detailed error
        handleError(context: context, exception: error);
      });
    };

    final Function(GameTemplate) buyGames = (template) async {
      final response = await appRouter.goTo<bool>(const GamesAccessPage());

      if (response == null) {
        return;
      }

      onGameTempalateSelected(template);
    };

    return LoadableView(
      isLoading: createRoomRequestState.isInProgress,
      backgroundColor: ColorRes.black80,
      child: CashFlowScaffold(
        title: Strings.chooseQuest,
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
                onGameTempalateSelected: multiplayerGamesCount <= 0
                    ? buyGames
                    : onGameTempalateSelected,
                loadGameTempalatesRequestState: getGameTemplatesRequestState,
                loadGameTemplates: () {
                  dispatch(GetGameTemplatesAction());
                },
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
    @required OperationState loadGameTempalatesRequestState,
    @required VoidCallback loadGameTemplates,
  }) {
    return LoadableListView<GameTemplate>(
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
        emptyStateWidget: EmptyWidget(),
        errorWidget: CommonErrorWidget(loadGameTemplates),
      ),
    );
  }
}
