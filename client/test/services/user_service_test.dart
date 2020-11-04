import 'package:cash_flow/models/domain/user/purchase_profile.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_api_client.dart';
import '../mocks/mock_firebase_auth.dart';
import '../mocks/mock_firebase_messaging.dart';
import '../mocks/mock_firestore.dart';
import '../mocks/mock_user_cache.dart';

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockFirestore = MockFirestore();
  final mockFirebaseMessaging = MockFirebaseMessaging();
  final mockApiClient = MockCashFlowApiClient();
  final mockUserCache = MockUserCache();

  UserService userService;

  setUp(() {
    reset(mockFirebaseAuth);
    reset(mockFirestore);
    reset(mockFirebaseMessaging);
    reset(mockApiClient);

    userService = UserService(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
      firebaseMessaging: mockFirebaseMessaging,
      userCache: mockUserCache,
      apiClient: mockApiClient,
    );
  });

  test('Requiring migration for old versioned profile', () async {
    const userId = 'user1';
    final userProfile = UserProfile(
      userId: userId,
      fullName: 'User Name',
    );

    final migratedUserProfile = userProfile.copyWith(
      purchaseProfile: PurchaseProfile(
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      ),
      profileVersion: 2,
      multiplayerGamePlayed: 0,
    );

    when(mockUserCache.getUserProfile()).thenAnswer((_) async => userProfile);
    when(mockApiClient.getUserProfile(userId)).thenAnswer((_) async {
      return migratedUserProfile;
    });

    final receivedUserProfile = await userService.loadUserFromServer(userId);

    expect(receivedUserProfile, migratedUserProfile);

    verifyInOrder([
      mockUserCache.getUserProfile(),
      mockApiClient.getUserProfile(userId),
      mockUserCache.setUserProfile(migratedUserProfile),
    ]);

    verifyNoMoreInteractions(mockUserCache);
    verifyNoMoreInteractions(mockApiClient);
    verifyZeroInteractions(mockFirestore);
    verifyZeroInteractions(mockFirebaseMessaging);
    verifyZeroInteractions(mockFirebaseAuth);
  });
}
