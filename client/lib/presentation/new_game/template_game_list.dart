import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/presentation/new_game/game_template_item.dart';
import 'package:cash_flow/presentation/new_game/game_template_list_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_list_widget.dart';
import 'package:cash_flow/widgets/progress/games_loadable_list_view.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class TemplateGameList extends HookWidget {
  const TemplateGameList({
    @required this.selectedItemId,
    @required this.onSelectionChanged,
  });

  final String selectedItemId;
  final void Function(String) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final vm = useGameTemplateListViewModel();
    final mediaQueryData = useAdaptiveMediaQueryData();

    return MediaQuery(
      data: mediaQueryData,
      child: LoadableView(
        isLoading: vm.templatesRequestState.isInProgress,
        backgroundColor: ColorRes.transparent,
        indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
        child: GamesLoadableListView<GameTemplate>(
          viewModel: LoadableListViewModel(
            items: vm.gameTemplates,
            itemBuilder: (i) => GameTemplateItem(
              selectedItemId: selectedItemId,
              gameTemplate: vm.gameTemplates.items[i],
              onStartNewGamePressed: vm.createNewGame,
              onContinueGamePressed: vm.continueGame,
              onSelectionChanged: onSelectionChanged,
            ),
            loadListRequestState: vm.templatesRequestState,
            loadList: vm.loadGameTemplates,
            emptyStateWidget: const EmptyListWidget(),
            errorWidget: CommonErrorWidget(vm.loadGameTemplates),
          ),
        ),
      ),
    );
  }
}
