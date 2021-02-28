import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/multiplayer/actions/create_room_action.dart';
import 'package:cash_flow/features/multiplayer/actions/select_multiplayer_game_template_action.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/widgets/games_loadable_list_view.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/presentation/purchases/games_access_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultiplayerGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final getGameTemplatesRequestState = useGlobalState((s) {
      return s.getOperationState(Operation.loadGameTemplates);
    });

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final dispatch = useDispatcher();
    final availableMultiplayerGamesCount = useAvailableMultiplayerGamesCount();

    final Function(GameTemplate) onGameTemplateSelected = (template) async {
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

      onGameTemplateSelected(template);
    };

    useEffect(() {
      AnalyticsSender.multiplayerLevelsPageOpen();
      SessionTracker.multiplayerGameCreated.start();
      return null;
    }, []);

    return LoadableView(
      isLoading: getGameTemplatesRequestState.isInProgress,
      backgroundColor: ColorRes.transparent,
      indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
      child: _TemplateList(
        gameTemplates: gameTemplates,
        onGameTemplateSelected: availableMultiplayerGamesCount <= 0
            ? buyGames
            : onGameTemplateSelected,
        loadGameTemplatesRequestState: getGameTemplatesRequestState,
        loadGameTemplates: () {
          dispatch(GetGameTemplatesAction());
        },
      ),
    );
  }
}

class _TemplateList extends HookWidget {
  const _TemplateList({
    @required this.gameTemplates,
    @required this.onGameTemplateSelected,
    @required this.loadGameTemplatesRequestState,
    @required this.loadGameTemplates,
    Key key,
  }) : super(key: key);

  final StoreList<GameTemplate> gameTemplates;
  final void Function(GameTemplate template) onGameTemplateSelected;
  final OperationState loadGameTemplatesRequestState;
  final VoidCallback loadGameTemplates;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = useAdaptiveMediaQueryData();

    return MediaQuery(
      data: mediaQueryData,
      child: GamesLoadableListView<GameTemplate>(
        viewModel: LoadableListViewModel(
          items: gameTemplates,
          itemBuilder: (i) => GameTemplateItem(
            gameTemplate: gameTemplates.items[i],
            onStartNewGamePressed: (template) {
              onGameTemplateSelected(template);
              AnalyticsSender.multiplayerTemplateSelected(template.name);
            },
          ),
          loadListRequestState: loadGameTemplatesRequestState,
          loadList: loadGameTemplates,
          emptyStateWidget: EmptyWidget(),
          errorWidget: CommonErrorWidget(loadGameTemplates),
        ),
      ),
    );
  }
}
