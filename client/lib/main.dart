import 'dart:async';

import 'package:alice/alice.dart';
import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/store/store.dart';
import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/cash_flow_app.dart';
import 'package:cash_flow/configuration/api_client.dart';
import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:cash_flow/configuration/control_panel.dart';
import 'package:cash_flow/configuration/error_reporting.dart';
import 'package:cash_flow/configuration/firestore.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/configuration/ui_kit.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/login/login_actions.dart';

Future<void> main({
  @required CashApiEnvironment environment,
}) async {
  AppConfiguration.init(environment: environment);
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  final alice = Alice(navigatorKey: appRouter.navigatorKey);
  final sharedPreferences = await SharedPreferences.getInstance();
  final apiClient = configureApiClient(alice, environment);

  if (environment == CashApiEnvironment.development) {
    await configureFirestoreLocalEnvironment();
  }

  configurePurchases();
  configureControlPanel(alice, apiClient);
  configureErrorReporting();
  setOrientationPortrait();
  configureUiKit();

  final rootEpic = createRootEpic(
    apiClient,
    sharedPreferences,
    tokenStorage,
  );

  final storeProvider = configureStoreProvider(rootEpic);
  ReduxConfig.storeProvider = storeProvider;
  final dispatch = ReduxConfig.storeProvider.store.dispatch;

  Intl.defaultLocale = 'ru';
  await initializeDateFormatting('ru');

  final currentUser = await FirebaseAuth.instance.currentUser();

  final isAuthorized = currentUser != null;
  dispatch(SetCurrentUserAction(user: currentUser));

  runZonedGuarded<Future<void>>(() async {
    runApp(
      CashFlowApp(
        store: storeProvider.store,
        isAuthorised: isAuthorized,
      ),
    );
  }, Crashlytics.instance.recordError);
}

void configurePurchases() {
  InAppPurchaseConnection.enablePendingPurchases();
}

void configureAnalytics(CashApiEnvironment environment) {
  if (environment == CashApiEnvironment.production) {
    AnalyticsSender.isEnabled = true;
  } else {
    AnalyticsSender.isEnabled = false;
  }
}
