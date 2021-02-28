import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/app_hooks.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/presentation/onboarding/onboarding_page.dart';
import 'package:cash_flow/resources/colors.dart';
// ignore: implementation_imports
import 'package:dash_kit_control_panel/src/services/device_preview_mode.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CashFlowApp extends HookWidget {
  CashFlowApp({
    @required this.isAuthorised,
    @required this.isFirstLaunch,
  }) : super(key: GlobalKey());

  final bool isAuthorised;
  final bool isFirstLaunch;

  @override
  Widget build(BuildContext context) {
    final isJoiningToRoom = useGlobalState(
      (s) => s.getOperationState(Operation.joinRoom).isInProgress,
    );

    // usePushNotificationsPermissionRequest(useDelay: true);
    useUserPushTokenUploader();
    // usePushNotificationsHandler();
    useDynamicLinkHandler();
    // useDeepLinkHandler();

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) => LoadableView(
        backgroundColor: ColorRes.black80,
        isLoading: isJoiningToRoom,
        child: DevicePreviewWrapper(child: widget),
      ),
      navigatorKey: appRouter.navigatorKey,
      navigatorObservers: [
        ...getAnalyticsObservers(),
      ],
      home: _getHomePage(),
      theme: theme,
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

  Widget _getHomePage() {
    if (isFirstLaunch) {
      return const OnBoardingPage();
    }

    return isAuthorised ? const MainPage() : LoginPage();
  }
}

class DevicePreviewWrapper extends StatelessWidget {
  const DevicePreviewWrapper({@required this.child}) : assert(child != null);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DevicePreviewMode.onModeChanged,
      builder: (context, snapShoot) => DevicePreview(
        enabled: false,
        builder: (context) => child,
      ),
    );
  }

  static Widget appBuilder(BuildContext context, Widget widget) {
    return DevicePreview.appBuilder(context, widget);
  }
}
