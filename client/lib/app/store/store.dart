import 'package:cash_flow/app/app_reducer.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/environment.dart';
import 'package:cash_flow/app/root_epic.dart';
import 'package:cash_flow/services/firebase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final firestore = Firestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  const environment = Environment(
    baseUrl: 'https://cash-flow-staging.appspot.com',
  );

  final userService = UserService(
    environment: environment,
    firebaseAuth: firebaseAuth,
  );
  final firebaseService = FirebaseService(firestore: firestore);

  return rootEpic(userService: userService, firebaseService: firebaseService);
}
