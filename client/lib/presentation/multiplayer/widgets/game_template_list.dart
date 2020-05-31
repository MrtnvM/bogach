import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/multiplayer/create_room_page.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class GameTemplateList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final requestState = useGlobalState(
      (s) => s.newGame.getGameTemplatesRequestState,
    );

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final gameAcitons = useGameActions();
    final multiplayerActions = useMultiplayerActions();

    final onGameTempalateSelected = (template) {
      multiplayerActions.selectGameTemplate(template);
      appRouter.goTo(CreateRoomPage());
    };

    return Loadable(
      isLoading: requestState.isInProgress,
      backgroundColor: ColorRes.mainGreen,
      child: LoadableList<GameTemplate>(
        viewModel: LoadableListViewModel(
          items: gameTemplates,
          itemBuilder: (i) => GameTemplateItem(
            gameTemplate: gameTemplates.items[i],
            onTemplateSelected: onGameTempalateSelected,
          ),
          loadListRequestState: requestState,
          loadList: gameAcitons.loadGameTemplates,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
