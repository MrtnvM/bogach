import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/multiplayer/actions/add_friend_to_storage_action.dart';
import 'package:cash_flow/features/multiplayer/actions/add_friends_action.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

import '../app_state.dart';

Function(String) useAddFriend() {
  final context = useContext();
  final dispatch = useDispatcher();

  return (inviterId) async {
    final user = StoreProvider.state<AppState>(context)?.profile.currentUser;
    final usersAddToFriendsStorage = GetIt.I.get<UsersAddToFriendsStorage>();

    try {
      if (user == null) {
        usersAddToFriendsStorage.addUserId(inviterId);
        // TODO(Artem): я правильно понял?
        return;
      }

      await dispatch(AddFriendToStorageAction(userAddToFriendId: inviterId));
      await dispatch(AddFriendsAction(userId: user.id));

      AnalyticsSender.accountInvitationAccepted();
    } catch (error) {
      AnalyticsSender.accountInvitationAcceptRequestFailed();
      Fimber.e('Failed to add user to friends', ex: error);
    }
  };
}
