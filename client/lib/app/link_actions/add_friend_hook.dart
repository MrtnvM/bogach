import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/multiplayer/actions/add_friends_action.dart';
import 'package:cash_flow/features/multiplayer/actions/add_friend_to_storage_action.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

Function(String) useAddFriend() {
  final context = useContext();
  final dispatch = useDispatcher();

  return (inviterId) async {
    final user = StoreProvider.state<AppState>(context).profile.currentUser;
    final usersAddToFriendsStorage = GetIt.I.get<UsersAddToFriendsStorage>();

    try {
      if (user == null) {
        usersAddToFriendsStorage.addUserId(inviterId);
      }

      await dispatch(AddFriendToStorageAction(userAddToFriendId: inviterId));
      await dispatch(AddFriendsAction(userId: user.id));

      AnalyticsSender.accountInvitationAccepted();
    } catch (error) {
      AnalyticsSender.accountInvitationAcceptRequestFailed();
      Logger.e(error);
    }
  };
}
