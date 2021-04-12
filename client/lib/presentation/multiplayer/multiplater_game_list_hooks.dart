import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

StoreList<GameTemplate> useMultiplayerGameTemplates() {
  return useGlobalState((s) {
    final completedGames =
        s.profile.currentUser?.completedGames?.multiplayerGames ?? [];
    final templates = StoreList(s.newGame.gameTemplates.items.toList());

    templates.updateList(templates.items.rebuild((b) => b.sort((a, b) {
          final aIndex = completedGames.indexWhere((e) => e.templateId == a.id);
          final bIndex = completedGames.indexWhere((e) => e.templateId == b.id);

          if (aIndex == -1 && bIndex == -1) {
            return 0;
          } else if (aIndex == -1) {
            return -1;
          } else if (bIndex == -1) {
            return 1;
          }

          return aIndex.compareTo(bIndex);
        })));

    return templates;
  });
}
