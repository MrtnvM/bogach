import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

void useSubscriptionToPurchases() {
  final actionRunner = useActionRunner();

  useEffect(() {
    actionRunner.runAction(StartListeningPurchasesAction());
    return () => actionRunner.runAction(StopListeningPurchasesAction());
  }, []);
}

void useUserPushTokenUploader() {
  final currentUser = useCurrentUser();
  final actionRunner = useActionRunner();

  usePushTokenSubscription((token) {
    if (currentUser != null) {
      actionRunner.runAction(SendDevicePushTokenAsyncAction(
        userId: currentUser.userId,
        pushToken: token,
      ));
    }
  }, [currentUser?.userId]);
}

void usePushNotificationsHandler() {
  final multiplayerActions = useMultiplayerActions();

  usePushMessageSubscription((data) {
    final type = data['type'];

    switch (type) {
      case 'go_to_room':
        final roomId = data['roomId'];

        multiplayerActions.joinRoom(roomId).then((value) async {
          await Future.delayed(const Duration(milliseconds: 50));

          appRouter.goToRoot();
          appRouter.goTo(RoomPage());
        }).catchError((_) {
          // TODO(Maxim): Add retry alert
        });
    }
  });
}
