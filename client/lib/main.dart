import 'dart:async';

import 'package:alice/alice.dart';
import 'package:cash_flow/app/store/store.dart';
import 'package:cash_flow/cash_flow_app.dart';
import 'package:cash_flow/configuration/api_client.dart';
import 'package:cash_flow/configuration/control_panel.dart';
import 'package:cash_flow/configuration/error_reporting.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/configuration/ui_kit.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureErrorReporting();
  setOrientationPortrait();
  configureControlPanel();
  configureUiKit();

  final alice = Alice(navigatorKey: appRouter.navigatorKey);
  final sharedPreferences = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage();
  final environment = stagingEnvironment;
  final apiClient = configureApiClient(alice, environment);

  final rootEpic = createRootEpic(
    apiClient,
    sharedPreferences,
    tokenStorage,
  );

  final storeProvider = configureStoreProvider(rootEpic);
  ReduxConfig.storeProvider = storeProvider;

  Intl.defaultLocale = 'ru';
  await initializeDateFormatting('ru');
  final isAuthorized = await tokenStorage.isAuthorized();

  runZoned<Future<void>>(() async {
    runApp(CashFlowApp(
      store: storeProvider.store,
      isAuthorised: isAuthorized,
    ));
  }, onError: Crashlytics.instance.recordError);
}
