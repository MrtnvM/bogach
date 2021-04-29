import 'dart:async';

import 'package:alice_lightweight/alice.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/store/store.dart';
import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/cache/user_cache.dart';
import 'package:cash_flow/cash_flow_app.dart';
import 'package:cash_flow/configuration/analytics.dart';
import 'package:cash_flow/configuration/api_client.dart';
import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:cash_flow/configuration/control_panel.dart';
import 'package:cash_flow/configuration/error_reporting.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/configuration/ui_kit.dart';
import 'package:cash_flow/features/config/actions/load_config_action.dart';
import 'package:cash_flow/features/config/actions/track_online_status_action.dart';
import 'package:cash_flow/features/profile/actions/set_current_user_action.dart';
import 'package:cash_flow/features/purchase/actions/listening_purchases_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/utils/core/launch_counter.dart';
import 'package:cash_flow/utils/core/logging/firebase_tree.dart';
import 'package:cash_flow/utils/core/logging/logger_tree.dart';
import 'package:cash_flow/utils/core/logging/rollbar_tree.dart';
import 'package:cash_flow/utils/debug.dart';
import 'package:cash_flow/widgets/utils/feedback_widget.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/profile/actions/start_listening_profile_updates_action.dart';

Future<void> main({
  CashApiEnvironment environment = CashApiEnvironment.production,
}) async {
  initLogging(environment.name, environment.isLoggerEnabled);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
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

  await configureDependencyInjection(
    environment,
    apiClient,
    sharedPreferences,
    tokenStorage,
    userCache,
  );

  final store = configureStore();

  Intl.defaultLocale = 'ru';

  final currentUser = await userCache.getUserProfile();

  final isAuthorized = currentUser?.userId != null;
  store.dispatch(SetCurrentUserAction(currentUser));
  if (isAuthorized) {
    store.dispatch(StartListeningProfileUpdatesAction(currentUser!.id));
  }
  store.dispatch(StartListeningPurchasesAction());

  store.dispatchFuture(LoadConfigAction()).then((_) {
    store.dispatch(TrackOnlineStatusAction());
  });

  final isFirstLaunch = launchCounter.isFirstLaunch();
  if (isFirstLaunch) {
    await tokenStorage.clearTokens();
  }

  launchCounter.incrementLaunchCount();

  AnalyticsSender.appLaunched();
  SessionTracker.gameLaunched.start();

  MobileAds.instance.initialize();

  runZonedGuarded<Future<void>>(() async {
    runApp(
      StoreProvider<AppState>(
        store: store,
        child: FeedbackWidget(
          child: CashFlowApp(
            isAuthorised: isAuthorized,
            isFirstLaunch: isFirstLaunch,
          ),
        ),
      ),
    );
  }, (error, stack) {
    Fimber.e('runZonedGuarded error:', ex: error, stacktrace: stack);
  });
}

void configurePurchases() {
  InAppPurchaseConnection.enablePendingPurchases();
}

void initLogging(String environmentName, isLoggerEnabled) {
  release(() {
    Fimber.plantTree(FirebaseReportingTree());
    Fimber.plantTree(RollbarTree(environmentName: environmentName));
  });

  if (isLoggerEnabled) {
    Logger.init();
    Logger.enabled = true;
    Fimber.plantTree(LoggerTree());
  }
}
