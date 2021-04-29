import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/user/last_games/last_game_info.dart';
import 'package:flutter/foundation.dart';

List<GameTemplate> sortTemplates({
  @required BuiltList<GameTemplate> templates,
  @required List<LastGameInfo> completedGames,
}) {
  assert(templates != null);
  assert(completedGames != null);

  return templates
      .rebuild((b) => b.sort((a, b) {
            final aIndex =
                completedGames.indexWhere((e) => e.templateId == a.id);
            final bIndex =
                completedGames.indexWhere((e) => e.templateId == b.id);

            if (aIndex == -1 && bIndex == -1) {
              return 0;
            } else if (aIndex == -1) {
              return -1;
            } else if (bIndex == -1) {
              return 1;
            }

            return aIndex.compareTo(bIndex);
          }))
      .toList();
}
