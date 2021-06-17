import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notification_permissions/notification_permissions.dart';

FirebaseMessaging useFirebaseMessaging() {
  return useMemoized(() => FirebaseMessaging.instance);
}

void usePushNotificationsPermissionRequest({
  bool useDelay = false,
  Duration delay = const Duration(seconds: 2),
}) {
  final firebaseMessaging = useFirebaseMessaging();

  useEffect(() {
    final requestDelay = useDelay ? delay : const Duration();

    Future.delayed(requestDelay).then((_) async {
      firebaseMessaging.requestPermission();
    });

    return null;
  }, []);
}

PermissionStatus? usePushNotificationsSettings() {
// Since firebase_messaging	^8.0.0-dev.15 you can get notifications settings:
// NEW: [Apple] Added support for getNotificationSettings().
// But it requires for update of firebase_core to	^0.7.0
// So right now notification_permissions lib is used.
  return useFuture(
    NotificationPermissions.getNotificationPermissionStatus(),
    initialData: [],
  ).data as PermissionStatus?;
}

void usePushTokenSubscription(
  void onTokenUpdated(String? token), [
  List? keys,
]) {
  final firebaseMessaging = useFirebaseMessaging();

  useEffect(() {
    firebaseMessaging.getToken().then(onTokenUpdated);

    final tokenRefreshingSubscription =
        firebaseMessaging.onTokenRefresh.listen(onTokenUpdated);

    return tokenRefreshingSubscription.cancel;
  }, keys);
}

void usePushMessageSubscription(void onMessage(Map<String, dynamic> message)) {
  final onPushNotification = (message) {
    if (message?.data != null) {
      onMessage(message.data);
    }
  };

  useEffect(() {
    FirebaseMessaging.instance.getInitialMessage().then(onPushNotification);
    FirebaseMessaging.onMessage.listen(onPushNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(onPushNotification);

    return null;
  }, []);
}
