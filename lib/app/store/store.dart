import 'package:cash_flow/app/app_reducer.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/root_epic.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'middleware/log_middleware.dart';

StoreProvider<AppState> configureStoreProvider(Epic<AppState> rootEpic) {
  final appReducer = AppReducer();
  final logMiddleware = LogMiddleware();

  return StoreProvider(
    initialState: AppState.initial(),
    appReducer: appReducer,
    appEpic: rootEpic,
    middleware: [
      logMiddleware,
    ],
  );
}

Epic<AppState> createRootEpic(
  SharedPreferences sharedPreferences,
) {
  return rootEpic();
}
