import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/profile/actions/send_device_push_token_action.dart';

import 'app_navigation_hooks/use_join_room.dart';

void useUserPushTokenUploader() {
  final currentUser = useCurrentUser();
  final dispatch = useDispatcher();

  usePushTokenSubscription((token) {
    if (currentUser != null) {
      dispatch(SendDevicePushTokenAction(
        userId: currentUser.userId,
        pushToken: token,
      ));
    }
  }, [currentUser?.userId]);
}

void usePushNotificationsHandler() {
  final joinRoom = useJoinRoom();

  usePushMessageSubscription((data) {
    final type = data['type'];

    switch (type) {
      case 'go_to_room':
        final roomId = data['roomId'];
        joinRoom(roomId);
        break;
    }
  });
}
