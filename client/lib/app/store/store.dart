import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/app/app_reducer.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/root_epic.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
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
  CashFlowApiClient apiClient,
  SharedPreferences sharedPreferences,
  TokenStorage tokenStorage,
) {
  final firestore = Firestore.instance;
  final firebaseDatabase = FirebaseDatabase.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseMessaging = FirebaseMessaging();

  final gameService = GameService(
    apiClient: apiClient,
    firestore: firestore,
    firebaseDatabase: firebaseDatabase,
  );

  final userService = UserService(
    firebaseAuth: firebaseAuth,
    firestore: firestore,
    firebaseMessaging: firebaseMessaging,
  );

  final purchaseService = PurchaseService();

  return rootEpic(
    userService: userService,
    gameService: gameService,
    purchaseService: purchaseService,
  );
}
