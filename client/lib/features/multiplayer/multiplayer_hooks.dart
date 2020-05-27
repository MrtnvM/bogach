import 'package:cash_flow/features/multiplayer/multiplayer_actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

_MultiplayerActions useMultiplayerActions() {
  final actionRunner = useActionRunner();

  return useMemoized(() {
    return _MultiplayerActions(
      searchUsers: (searchString) {
        actionRunner.runAction(QueryUserProfilesAsyncAction(searchString));
      },
    );
  });
}

class _MultiplayerActions {
  _MultiplayerActions({@required this.searchUsers});

  final void Function(String searchString) searchUsers;
}
