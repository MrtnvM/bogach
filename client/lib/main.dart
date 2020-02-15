import 'dart:async';

import 'package:cash_flow/app/store/store.dart';
import 'package:cash_flow/cash_flow_app.dart';
import 'package:cash_flow/configuration/error_reporting.dart';
import 'package:cash_flow/configuration/system_ui.dart';
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
  configureSystemUi();

  final sharedPreferances = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage();

  final rootEpic = createRootEpic(
    sharedPreferances,
    tokenStorage,
  );

  final storeProvider = configureStoreProvider(rootEpic);
  ReduxConfig.storeProvider = storeProvider;

  Intl.defaultLocale = 'ru';
  await initializeDateFormatting('ru');

  runZoned<Future<void>>(() async {
    runApp(CashFlowApp(
      store: storeProvider.store,
      isAuthorised: false,
    ));
  }, onError: Crashlytics.instance.recordError);
}
