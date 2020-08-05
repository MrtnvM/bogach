import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/app_hooks.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/utils/core/device_preview.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
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
    final isJoiningToRoom = useGlobalState(
      (s) => s.multiplayer.joinRoomRequestState.isInProgress,
    );

    useSubscriptionToPurchases();
    usePushNotificationsPermissionRequest(useDelay: true);
    useUserPushTokenUploader();
    usePushNotificationsHandler();
    // useDynamicLinkHandler();
    useDeepLinkHandler();

    final theme = Theme.of(context).copyWith(
      scaffoldBackgroundColor: ColorRes.scaffoldBackground,
      accentColor: Colors.white,
      primaryColor: ColorRes.mainGreen,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

    final homePage = isAuthorised ? const MainPage() : const LoginPage();

    return redux.StoreProvider(
      store: store,
      child: StreamBuilder(
        stream: DevicePreviewMode.onModeChanged,
        builder: (context, snapShoot) => DevicePreview(
          enabled: snapShoot.hasData && snapShoot.data,
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, widget) => Loadable(
              backgroundColor: ColorRes.black80,
              isLoading: isJoiningToRoom,
              child: DevicePreview.appBuilder(context, widget),
            ),
            navigatorKey: appRouter.navigatorKey,
            navigatorObservers: [
              ...getAnalyticsObservers(),
            ],
            home: homePage,
            theme: theme,
          ),
        ),
      ),
    );
  }

  List<RouteObserver> getAnalyticsObservers() {
    if (!AnalyticsSender.isEnabled) {
      return [];
    }

    return [
      FirebaseAnalyticsObserver(
        analytics: AnalyticsSender.firebaseAnalytics,
      )
    ];
  }
}
