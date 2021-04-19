import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/utils/sorts/template_sorts.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

StoreList<GameTemplate> useMultiplayerGameTemplates() {
  return useGlobalState((s) {
    final completedGames =
        s.profile.currentUser?.completedGames?.multiplayerGames ?? [];
    final templates = StoreList(s.newGame.gameTemplates.items.toList());

    templates.updateList(sortTemplates(
      templates: templates.items,
      completedGames: completedGames,
    ));

    return templates;
  });
}
