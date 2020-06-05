import 'dart:io';

import 'package:cash_flow/app/app_hooks.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/utils/core/device_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';
import 'package:flutter_redux/flutter_redux.dart' as redux;
import 'package:redux/redux.dart';

class CashFlowApp extends HookWidget {
  CashFlowApp({
    @required this.store,
    @required this.isAuthorised,
  }) : super(key: GlobalKey());

  final Store<AppState> store;
  final bool isAuthorised;

  @override
  Widget build(BuildContext context) {
    final currentUser = useCurrentUser();
    final isJoiningToRoom = useState(false);

    useSubscriptionToPurchases();
    usePushNotificationsPermissionRequest(useDelay: true);

    usePushTokenSubscription(currentUser?.id, (token) {
      if (currentUser == null) {
        return;
      }

      Firestore.instance
          .collection('devices')
          .document(currentUser.id)
          .setData({'token': token, 'device': Platform.operatingSystem});
    });

    final multiplayerActions = useMultiplayerActions();
    usePushMessageSubscription((message) {
      final Map<String, dynamic> data = message['data'] ?? message;
      if (data == null) {
        return;
      }

      final type = data['type'];

      switch (type) {
        case 'go_to_room':
          final roomId = data['roomId'];

          isJoiningToRoom.value = true;

          multiplayerActions.joinRoom(roomId).then((value) async {
            isJoiningToRoom.value = false;

            await Future.delayed(const Duration(milliseconds: 300));
            appRouter.goToRoot();
            appRouter.goTo(RoomPage());
          }).catchError((_) {
            isJoiningToRoom.value = false;

            // TODO(Maxim): Add retry alert
          });
      }
    });

    return redux.StoreProvider(
      store: store,
      child: StreamBuilder(
        stream: DevicePreviewMode.onModeChanged,
        builder: (context, snapShoot) => DevicePreview(
          enabled: snapShoot.hasData && snapShoot.data,
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: DevicePreview.appBuilder,
            navigatorKey: appRouter.navigatorKey,
            home: Loadable(
              isLoading: isJoiningToRoom.value,
              child: _HomePage(isAuthorised: isAuthorised),
            ),
            theme: Theme.of(context).copyWith(
              scaffoldBackgroundColor: ColorRes.scaffoldBackground,
              accentColor: Colors.white,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key key, this.isAuthorised}) : super(key: key);

  final bool isAuthorised;

  @override
  Widget build(BuildContext context) {
    return isAuthorised ? const MainPage() : const LoginPage();
  }
}
