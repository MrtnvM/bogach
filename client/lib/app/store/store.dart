import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/cache/user_cache.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

StoreProvider<AppState> configureStoreProvider() {
  return StoreProvider(
    initialState: AppState.initial(),
    actionObservers: [ReduxActionObserver.instance],
  );
}

void configureDependencyInjection(
  CashFlowApiClient apiClient,
  SharedPreferences sharedPreferences,
  TokenStorage tokenStorage,
  UserCache userCache,
) {
  final firestore = FirebaseFirestore.instance;
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
    userCache: userCache,
  );

  final purchaseService = PurchaseService(
    apiClient: apiClient,
  );

  GetIt.I.registerSingleton<GameService>(gameService);
  GetIt.I.registerSingleton<UserService>(userService);
  GetIt.I.registerSingleton<PurchaseService>(purchaseService);
}
