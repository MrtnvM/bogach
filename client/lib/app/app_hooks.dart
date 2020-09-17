import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/dynamic_link_hooks.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:uni_links/uni_links.dart';

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

    Logger.i('APP CAPTURE DYNAMIC LINK:\n$link');

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

void useDeepLinkHandler() {
  final appActions = useAppActions();

  useEffect(() {
    // ignore: avoid_types_on_closure_parameters
    final onDeepLink = (String deepLink) {
      Logger.i('APP CAPTURE DEEP LINK:\n$deepLink');

      if (deepLink == null) {
        return;
      }

      final uri = Uri.parse(deepLink);

      final isLinkTo = (path) {
        return uri.path.contains(path) ?? false;
      };

      if (isLinkTo(DynamicLinks.roomInvite)) {
        final roomId = uri.queryParameters['room_id'];
        appActions.joinRoom(roomId);
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

_AppActions useAppActions() {
  final multiplayerActions = useMultiplayerActions();
  final failedJoiningToRoomAlert = useWarningAlert(
    message: (_) => Strings.joinRoomError,
    needCancelButton: true,
  );

  return useMemoized(
    () => _AppActions(
      joinRoom: (roomId) {
        VoidCallback joinRoom;
        joinRoom = () {
          multiplayerActions.joinRoom(roomId).then((value) async {
            await Future.delayed(const Duration(milliseconds: 50));

            appRouter.goToRoot();
            appRouter.goTo(RoomPage());
          }).catchError((error) {
            failedJoiningToRoomAlert(error, joinRoom);
            Logger.e('ERROR ON JOINING TO ROOM ($roomId):\n$error');
          });
        };

        joinRoom();
      },
    ),
    [],
  );
}

class _AppActions {
  _AppActions({
    @required this.joinRoom,
  });

  final void Function(String) joinRoom;
}
