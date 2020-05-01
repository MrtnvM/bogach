import 'dart:async';

import 'package:alice/alice.dart';
import 'package:cash_flow/app/store/store.dart';
import 'package:cash_flow/cash_flow_app.dart';
import 'package:cash_flow/configuration/api_client.dart';
import 'package:cash_flow/configuration/control_panel.dart';
import 'package:cash_flow/configuration/error_reporting.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/configuration/ui_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/login/login_actions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureErrorReporting();
  setOrientationPortrait();

  final sharedPreferences = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage();

  final alice = Alice();
  final apiClient = configureApiClient(
    environment: _getApiEnvironment(),
    alice: alice,
  );

  configureControlPanel();
  configureUiKit();

  final rootEpic = createRootEpic(
    sharedPreferences,
    tokenStorage,
    apiClient,
  );

  final storeProvider = configureStoreProvider(rootEpic);
  ReduxConfig.storeProvider = storeProvider;
  final dispatch = ReduxConfig.storeProvider.store.dispatch;

  Intl.defaultLocale = 'ru';
  await initializeDateFormatting('ru');

  final currentUser = await FirebaseAuth.instance.currentUser();

  final isAuthorized = currentUser != null;
  dispatch(SetCurrentUserAction(user: currentUser));

  runZoned<Future<void>>(() async {
    runApp(CashFlowApp(
      store: storeProvider.store,
      isAuthorised: isAuthorized,
    ));
  }, onError: Crashlytics.instance.recordError);
}

ApiEnvironment _getApiEnvironment() {
  return const ApiEnvironment(
    baseUrl: 'https://europe-west2-cash-flow-staging.cloudfunctions.net/',
  );
}
