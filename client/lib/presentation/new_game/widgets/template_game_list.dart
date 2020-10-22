import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/features/new_game/actions/start_singleplayer_game_action.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/new_game/widgets/game_template_item.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class TemplateGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final templatesRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.loadGameTemplates),
    );

    final createGameRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.createGame),
    );

    final gameTemplates = useGlobalState((s) => s.newGame.gameTemplates);
    final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);
    final dispatch = useDispatcher();

    void Function(GameTemplate) createNewGame;
    createNewGame = (template) {
      dispatch(StartSinglePlayerGameAction(templateId: template.id))
          .then((_) => isTutorialPassed
              ? appRouter.goTo(const GameBoard())
              : appRouter.goTo(const TutorialPage()))
          .catchError(
            (e) => handleError(
              context: context,
              exception: e,
              onRetry: () => createNewGame(template),
            ),
          );
    };

    final isLoading = templatesRequestState.isInProgress ||
        createGameRequestState.isInProgress;

    final loadGameTemplates = () => dispatch(GetGameTemplatesAction());

    return LoadableView(
      isLoading: isLoading,
      backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
      child: LoadableListView<GameTemplate>(
        viewModel: LoadableListViewModel(
          items: gameTemplates,
          itemBuilder: (i) => GameTemplateItem(
            gameTemplate: gameTemplates.items[i],
            onTemplateSelected: (template) {
              AnalyticsSender.templateSelected(template.name);
              createNewGame(template);
            },
          ),
          loadListRequestState: templatesRequestState,
          loadList: loadGameTemplates,
          padding: const EdgeInsets.all(16),
          emptyStateWidget: EmptyWidget(),
          errorWidget: CommonErrorWidget(loadGameTemplates),
        ),
      ),
    );
  }
}
