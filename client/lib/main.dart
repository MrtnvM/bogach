import 'dart:async';

import 'package:alice_lightweight/alice.dart';
import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/store/store.dart';
import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/cache/user_cache.dart';
import 'package:cash_flow/cash_flow_app.dart';
import 'package:cash_flow/configuration/api_client.dart';
import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:cash_flow/configuration/control_panel.dart';
import 'package:cash_flow/configuration/error_reporting.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/configuration/ui_kit.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/utils/core/launch_counter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/login/login_actions.dart';

Future<void> main({
  @required CashApiEnvironment environment,
}) async {
  environment = environment ?? CashApiEnvironment.production;
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfiguration.init(environment: environment);

  final tokenStorage = TokenStorage();
  final alice = Alice(navigatorKey: appRouter.navigatorKey);
  final sharedPreferences = await SharedPreferences.getInstance();
  final userCache = UserCache(sharedPreferences);
  final apiClient = configureApiClient(alice, environment);
  final launchCounter = LaunchCounter(sharedPreferences);

  configurePurchases();
  configureControlPanel(alice, apiClient);
  configureErrorReporting();
  setOrientationPortrait();
  configureUiKit();

  final rootEpic = createRootEpic(
    apiClient,
    sharedPreferences,
    tokenStorage,
    userCache,
  );

  final storeProvider = configureStoreProvider(rootEpic);
  ReduxConfig.storeProvider = storeProvider;
  final dispatch = ReduxConfig.storeProvider.store.dispatch;

  Intl.defaultLocale = 'ru';
  await initializeDateFormatting('ru');

  final currentUser = userCache.getUserProfile();

  final isAuthorized = currentUser != null;
  dispatch(SetCurrentUserAction(user: currentUser));

  final isFirstLaunch = launchCounter.isFirstLaunch();
  if (isFirstLaunch) {
    await tokenStorage.clearTokens();
  }

  launchCounter.incrementLaunchCount();

  runZonedGuarded<Future<void>>(() async {
    runApp(
      CashFlowApp(
        store: storeProvider.store,
        isAuthorised: isAuthorized,
        isFirstLaunch: isFirstLaunch,
      ),
    );
  }, Crashlytics.instance.recordError);
}

void configurePurchases() {
  InAppPurchaseConnection.enablePendingPurchases();
}

void configureAnalytics(CashApiEnvironment environment) {
  if (environment == CashApiEnvironment.production ||
      environment == CashApiEnvironment.uat) {
    AnalyticsSender.isEnabled = true;
  } else {
    AnalyticsSender.isEnabled = false;
  }
}
