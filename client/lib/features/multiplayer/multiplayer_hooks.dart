import 'package:cash_flow/features/multiplayer/multiplayer_actions.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

_MultiplayerActions useMultiplayerActions() {
  final actionRunner = useActionRunner();

  return useMemoized(() {
    return _MultiplayerActions(
      searchUsers: (searchString) {
        actionRunner.runAction(
          QueryUserProfilesAsyncAction(searchString),
        );
      },
      selectGameTemplate: (gameTemplate) {
        actionRunner.runAction(
          SelectMultiplayerGameTemplateAction(gameTemplate),
        );
      },
    );
  });
}

class _MultiplayerActions {
  _MultiplayerActions({
    @required this.searchUsers,
    @required this.selectGameTemplate,
  });

  final void Function(String searchString) searchUsers;
  final void Function(GameTemplate gameTemplate) selectGameTemplate;
}
