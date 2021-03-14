import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/multiplayer/actions/add_friend_action.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Function(String) useAddFriend() {
  final context = useContext();
  final dispatch = useDispatcher();

  return (inviterId) {
    final user = StoreProvider.state<AppState>(context).profile.currentUser;

    if (user == null) {
      // TODO save in storage
    }

    dispatch(AddFriendAction(
      userId: user.id,
      userAddToFriendId: inviterId,
    ));
    // TODO clear storage if success
    // TODO schedule if fail
  };
}
