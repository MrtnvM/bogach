import 'dart:ui';

import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/profile/actions/load_profiles_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

String useUserId() {
  return useGlobalState((s) => s.profile.currentUser.userId);
}

UserProfile useCurrentUser() {
  return useGlobalState((s) => s.profile.currentUser);
}

List<UserProfile> useCurrentUserFriends() {
  final user = useCurrentUser();
  final dispatch = useDispatcher();
  final profiles = useGlobalState((s) => s.multiplayer.userProfiles);
  final friendsIds = user?.friends ?? [];

  useEffect(() {
    VoidCallback loadMissingProfiles;

    loadMissingProfiles = () {
      final missingProfilesIds = friendsIds //
          .where((userId) => profiles.getItem(userId) == null)
          .toList();

      final action = LoadProfilesAction(ids: missingProfilesIds);
      dispatch(action).catchError((error) async {
        Logger.e(error);

        await Future.delayed(const Duration(seconds: 2));
        loadMissingProfiles();
      });
    };

    loadMissingProfiles();

    return null;
  }, [friendsIds, profiles]);

  return friendsIds.map(profiles.getItem).toList();
}
