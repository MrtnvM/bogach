import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/store/cash_error_observer.dart';
import 'package:cash_flow/app/store/redux_action_logger.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:cash_flow/cache/user_cache.dart';
import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:cash_flow/services/config_service.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/multiplayer_service.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:cash_flow/services/updates_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

Store<AppState> configureStore() {
  final actionLogger = ReduxActionLogger();
  final actionObserver = ReduxActionObserver();
  GetIt.I.registerSingleton<ReduxActionObserver>(actionObserver);

  return Store(
    initialState: AppState.initial(),
    errorObserver: CashErrorObserver<AppState>(),
    actionObservers: [
      actionObserver,
      actionLogger,
    ],
  );
}

Future<void> configureDependencyInjection(
  CashApiEnvironment environment,
  CashFlowApiClient apiClient,
  SharedPreferences sharedPreferences,
  TokenStorage tokenStorage,
  UserCache userCache,
) async {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseMessaging = FirebaseMessaging.instance;
  final cloudStorage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;
  final remoteConfig = RemoteConfig.instance;
  var realtimeDatabase = FirebaseDatabase.instance;

  if (environment == CashApiEnvironment.development) {
    FirebaseFirestore.instance.settings = Settings(
      host: environment.firestoreHostUrl,
      sslEnabled: false,
    );

    realtimeDatabase = FirebaseDatabase(
      app: Firebase.app(),
      databaseURL: environment.realtimeDatabaseUrl,
    );
  }

  final gameService = GameService(
    apiClient: apiClient,
    firestore: firestore,
    realtimeDatabase: realtimeDatabase,
  );

  final userService = UserService(
    firebaseAuth: firebaseAuth,
    firestore: firestore,
    firebaseMessaging: firebaseMessaging,
    cloudStorage: cloudStorage,
    userCache: userCache,
    apiClient: apiClient,
  );

  final multiplayerService = MultiplayerService(
    firestore: firestore,
    apiClient: apiClient,
  );

  final purchaseService = PurchaseService(
    apiClient: apiClient,
    connection: InAppPurchaseConnection.instance,
  );

  final configService = ConfigService(
    preferences: sharedPreferences,
  );

  final updatesService = UpdatesService(
    remoteConfig: remoteConfig,
    preferences: sharedPreferences,
  );

  final usersAddToFriendsStorage = UsersAddToFriendsStorage(
    preferences: sharedPreferences,
  );

  GetIt.I.registerSingleton<GameService>(gameService);
  GetIt.I.registerSingleton<UserService>(userService);
  GetIt.I.registerSingleton<PurchaseService>(purchaseService);
  GetIt.I.registerSingleton<ConfigService>(configService);
  GetIt.I.registerSingleton<UpdatesService>(updatesService);
  GetIt.I.registerSingleton<MultiplayerService>(multiplayerService);
  GetIt.I.registerSingleton<UsersAddToFriendsStorage>(usersAddToFriendsStorage);
}
