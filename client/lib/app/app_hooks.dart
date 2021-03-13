import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/profile/actions/send_device_push_token_action.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uni_links/uni_links.dart';

import 'app_navigation_hooks/join_room_hook.dart';

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

void useDeepLinkHandler() {
  final joinRoom = useJoinRoom();

  useEffect(() {
    // ignore: avoid_types_on_closure_parameters
    final onDeepLink = (String deepLink) {
      Logger.i('APP CAPTURE DEEP LINK:\n$deepLink');

      if (deepLink == null) {
        return;
      }

      final uri = Uri.parse(deepLink);
      Logger.e('PARSED URI:\n${uri.toString()}');

      final path = uri.path;
      if (path.contains(DynamicLinks.join)) {
        final roomId = uri.queryParameters[DynamicLinks.roomInvite];
        joinRoom(roomId);
      }
    };

    final onDeepLinkError = (error) {
      Logger.e('ERROR ON HANDLING DEEP LINK:\n$error');
    };

    getInitialLink().then(onDeepLink).catchError(onDeepLinkError);

    final subscription = getLinksStream().listen(
      onDeepLink,
      onError: onDeepLinkError,
    );

    return subscription.cancel;
  }, []);
}
