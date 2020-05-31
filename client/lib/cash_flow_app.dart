import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/utils/core/device_preview.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_redux/flutter_redux.dart' as redux;
import 'package:redux/redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CashFlowApp extends StatefulWidget {
  CashFlowApp({
    @required this.store,
    @required this.isAuthorised,
  }) : super(key: GlobalKey<CashFlowAppState>());

  final Store<AppState> store;
  final bool isAuthorised;

  @override
  State<StatefulWidget> createState() => CashFlowAppState();
}

class CashFlowAppState extends State<CashFlowApp> with ReduxState {
  @override
  void initState() {
    super.initState();

    dispatch(StartListeningPurchasesAction());

    Future.delayed(const Duration(seconds: 2)).then((_) async {
      final firebaseMessaging = FirebaseMessaging();
      firebaseMessaging.requestNotificationPermissions();

      final token = await firebaseMessaging.getToken();
      print('Push token: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return redux.StoreProvider(
      store: widget.store,
      child: StreamBuilder(
        stream: DevicePreviewMode.onModeChanged,
        builder: (context, snapShoot) => DevicePreview(
          enabled: snapShoot.hasData && snapShoot.data,
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: DevicePreview.appBuilder,
            navigatorKey: appRouter.navigatorKey,
            home: widget.isAuthorised ? const MainPage() : const LoginPage(),
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

  @override
  void dispose() {
    dispatch(StopListeningPurchasesAction());

    super.dispose();
  }
}
