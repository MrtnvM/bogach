import 'dart:async';

import 'package:alice_lightweight/alice.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/app_state.dart';
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
import 'package:cash_flow/features/profile/actions/set_current_user_action.dart';
import 'package:cash_flow/features/purchase/actions/listening_purchases_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/utils/core/launch_counter.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/profile/actions/start_listening_profile_updates_action.dart';

Future<void> main({
  @required CashApiEnvironment environment,
}) async {
  environment = environment ?? CashApiEnvironment.production;
  WidgetsFlutterBinding.ensureInitialized();

  if (environment.isLoggerEnabled) {
    Logger.init();
    Logger.enabled = true;
  }

  await initializeFirebase(environment);
  await AppConfiguration.init(environment: environment);

  final tokenStorage = TokenStorage();
  const secureStorage = FlutterSecureStorage();
  final alice = Alice(navigatorKey: appRouter.navigatorKey);
  final sharedPreferences = await SharedPreferences.getInstance();
  const userCache = UserCache(secureStorage);
  final apiClient = configureApiClient(alice, environment);
  final launchCounter = LaunchCounter(sharedPreferences);

  configurePurchases();
  configureControlPanel(alice, apiClient);
  configureErrorReporting();
  setOrientationPortrait();
  configureUiKit();
  configureAnalytics(environment);

  configureDependencyInjection(
    environment,
    apiClient,
    sharedPreferences,
    tokenStorage,
    userCache,
  );

  final store = configureStore();

  Intl.defaultLocale = 'ru';
  await initializeDateFormatting('ru');

  final currentUser = await userCache.getUserProfile();

  final isAuthorized = currentUser != null;
  store.dispatch(SetCurrentUserAction(currentUser));
  if (isAuthorized) {
    store.dispatch(StartListeningProfileUpdatesAction(currentUser.id));
  }
  store.dispatch(StartListeningPurchasesAction());

  final isFirstLaunch = launchCounter.isFirstLaunch();
  if (isFirstLaunch) {
    await tokenStorage.clearTokens();
  }

  launchCounter.incrementLaunchCount();

  runZonedGuarded<Future<void>>(() async {
    runApp(
      StoreProvider<AppState>(
        store: store,
        child: CashFlowApp(
          isAuthorised: isAuthorized,
          isFirstLaunch: isFirstLaunch,
        ),
      ),
    );
  }, FirebaseCrashlytics.instance.recordError);
}

Future<void> initializeFirebase(CashApiEnvironment environment) async {
  await Firebase.initializeApp();
}

void configurePurchases() {
  InAppPurchaseConnection.enablePendingPurchases();
}

void configureAnalytics(CashApiEnvironment environment) {
  AnalyticsSender.isEnabled = environment.isAnalyticsEnabled;
}
