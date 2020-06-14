import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dynamic_link_hooks.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';
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
  final appAcitons = useAppActions();

  usePushMessageSubscription((data) {
    final type = data['type'];

    switch (type) {
      case 'go_to_room':
        final roomId = data['roomId'];
        appAcitons.joinRoom(roomId);
        break;
    }
  });
}

void useDynamicLinkHandler() {
  final appActions = useAppActions();

  useDynamicLinkSubscription((dynamicLink) {
    final link = dynamicLink.link;

    logger.d('APP CAPTURE DYNAMIC LINK:');
    logger.d(link);

    if (link == null) {
      return;
    }

    final isLinkTo = (path) {
      return link.path.contains(path) ?? false;
    };

    if (isLinkTo(DynamicLinks.roomInvite)) {
      final roomId = link.queryParameters['room_id'];
      appActions.joinRoom(roomId);
    }
  });
}

_AppActions useAppActions() {
  final multiplayerActions = useMultiplayerActions();

  return useMemoized(
    () => _AppActions(
      joinRoom: (roomId) {
        multiplayerActions.joinRoom(roomId).then((value) async {
          await Future.delayed(const Duration(milliseconds: 50));

          appRouter.goToRoot();
          appRouter.goTo(RoomPage());
        }).catchError((error) {
          // TODO(Maxim): Add retry alert
          logger.e('ERROR ON JOINING TO ROOM ($roomId):');
          logger.e(error);
        });
      },
    ),
  );
}

class _AppActions {
  _AppActions({
    @required this.joinRoom,
  });

  final void Function(String) joinRoom;
}
