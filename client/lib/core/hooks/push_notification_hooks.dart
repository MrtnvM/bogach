import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notification_permissions/notification_permissions.dart';

FirebaseMessaging useFirebaseMessaging() {
  return useMemoized(() => FirebaseMessaging());
}

void usePushNotificationsPermissionRequest({
  bool useDelay = false,
  Duration delay = const Duration(seconds: 2),
}) {
  final firebaseMessaging = useFirebaseMessaging();

  useEffect(() {
    final requestDelay = useDelay ? delay : const Duration();

    Future.delayed(requestDelay).then((_) async {
      firebaseMessaging.requestNotificationPermissions();
    });

    return null;
  }, []);
}

PermissionStatus usePushNotificationsSettings() {
// Since firebase_messaging	^8.0.0-dev.15 you can get notifications settings:
// NEW: [Apple] Added support for getNotificationSettings().
// But it requires for update of firebase_core to	^0.7.0
// So right now notification_permissions lib is used.
  return useFuture(NotificationPermissions.getNotificationPermissionStatus())
      .data;
}

void usePushTokenSubscription(void onTokenUpdated(String token), [List keys]) {
  final firebaseMessaging = useFirebaseMessaging();

  useEffect(() {
    firebaseMessaging.getToken().then(onTokenUpdated);

    final tokenRefreshingSubscription =
        firebaseMessaging.onTokenRefresh.listen(onTokenUpdated);

    return tokenRefreshingSubscription.cancel;
  }, keys);
}

void usePushMessageSubscription(void onMessage(Map<String, dynamic> message)) {
  final firebaseMessaging = useFirebaseMessaging();

  final void Function(Map<String, dynamic>) onPushNotification = (message) {
    final Map<String, dynamic> data =
        message['data']?.cast<String, dynamic>() ?? message;

    if (data != null) {
      onMessage(data);
    }
  };

  useEffect(() {
    firebaseMessaging.configure(
      onMessage: onPushNotification,
      onLaunch: onPushNotification,
      onResume: onPushNotification,
    );

    return null;
  }, []);
}
