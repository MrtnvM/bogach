import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

void usePushTokenSubscription(
  String userId,
  void Function(String) onTokenUpdated,
) {
  final firebaseMessaging = useFirebaseMessaging();

  useEffect(() {
    firebaseMessaging.getToken().then((token) {
      print('Push token: $token');
      onTokenUpdated(token);
    });

    final tokenRefreshingSubscription =
        firebaseMessaging.onTokenRefresh.listen(onTokenUpdated);

    return tokenRefreshingSubscription.cancel;
  }, [userId]);
}

void usePushMessageSubscription(void onMessage(Map<String, dynamic> message)) {
  final firebaseMessaging = useFirebaseMessaging();

  useEffect(() {
    firebaseMessaging.configure(
      onMessage: onMessage,
      onLaunch: onMessage,
      onResume: onMessage,
    );

    return null;
  }, []);
}

FirebaseMessaging useFirebaseMessaging() {
  return useMemoized(() => FirebaseMessaging());
}
