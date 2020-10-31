import 'dart:io';

import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/cache/user_cache.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/core/search_query_result.dart';
import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

class UserService {
  UserService({
    @required this.firebaseAuth,
    @required this.firestore,
    @required this.firebaseMessaging,
    @required this.userCache,
    @required this.apiClient,
  })  : assert(firebaseAuth != null),
        assert(firestore != null);

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseMessaging firebaseMessaging;
  final UserCache userCache;
  final CashFlowApiClient apiClient;

  Future<void> login({
    @required String email,
    @required String password,
  }) {
    return firebaseAuth
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .catchError(ErrorHandler().handleError);
  }

  Future<void> logout() async {
    await userCache.deleteUserProfile();
    await firebaseAuth.signOut();
  }

  Future<UserProfile> register({@required RegisterRequestModel model}) {
    return signUpUser(model).catchError(ErrorHandler().handleError);
  }

  Future<void> resetPassword({@required String email}) {
    return firebaseAuth
        .sendPasswordResetEmail(email: email)
        .catchError(ErrorHandler().handleError);
  }

  Future<String> loginViaFacebook({@required String token}) {
    return firebaseAuth
        .signInWithCredential(FacebookAuthProvider.credential(token))
        .then((response) => response.user.uid)
        .catchError(ErrorHandler().handleError);
  }

  Future<String> loginViaGoogle({
    @required String accessToken,
    @required String idToken,
  }) {
    return firebaseAuth
        .signInWithCredential(GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: idToken,
        ))
        .then((response) => response.user.uid)
        .catchError(ErrorHandler().handleError);
  }

  Future<String> loginViaApple({
    @required String accessToken,
    @required String idToken,
    @required String firstName,
    @required String lastName,
  }) {
    final authProvider = OAuthProvider('apple.com');
    final credential = authProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );

    final loginRequest = Future(() async {
      final response = await firebaseAuth.signInWithCredential(credential);
      final user = response.user;

      if (firstName != null && lastName != null) {
        await user.updateProfile(displayName: '$firstName $lastName');
      }

      return firebaseAuth.currentUser;
    });

    return loginRequest
        .catchError(ErrorHandler().handleError)
        .then((user) => user.uid);
  }

  Future<void> signUpUser(RegisterRequestModel model) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: model.email,
      password: model.password,
    );

    final user = firebaseAuth.currentUser;
    await user.updateProfile(displayName: model.nickName);

    return Future.value();
  }

  // TODO(maxim): Remove searching players
  Future<SearchQueryResult<UserProfile>> searchUsers(
    String searchString,
  ) async {
    final users = await firestore
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: searchString)
        .get()
        .then((snapshot) =>
            snapshot.docs.map((d) => UserProfile.fromJson(d.data())).toList());

    return SearchQueryResult(
      searchString: searchString,
      items: users,
    );
  }

  Future<UserProfile> loadCurrentProfile(String userId) async {
    final currentUserProfile = await userCache.getUserProfile();

    const requiredVersionOfProfile = 3;
    final currentVersionOfProfile = currentUserProfile?.profileVersion ?? 1;

    UserProfile updatedUserProfile;

    if (requiredVersionOfProfile > currentVersionOfProfile) {
      /// Requesting user profile through the server request will
      /// auto-migrate it to the newer version
      updatedUserProfile = await apiClient.getUserProfile(userId);
    } else {
      final snapshot = await firestore.collection('users').doc(userId).get();
      if (snapshot?.data() == null) {
        return null;
      }

      updatedUserProfile = UserProfile.fromJson(snapshot.data());
    }

    await userCache.setUserProfile(updatedUserProfile);

    return updatedUserProfile;
  }

  Future<List<UserProfile>> loadProfiles(List<String> profileIds) async {
    final profiles = await Future.wait(
      profileIds.map((id) => firestore.collection('users').doc(id).get()),
    );

    final emptyProfiles = profiles //
        .where((p) => p.data == null)
        .map((p) => p.id);

    if (emptyProfiles.isNotEmpty) {
      Logger.d('WARNING: not found profiles with IDs: $emptyProfiles');
    }

    return profiles
        .where((p) => p.data != null)
        .map((snapshot) => UserProfile.fromJson(snapshot.data()))
        .toList();
  }

  Future<UserProfile> loadUserFromServer(userId) async {
    return await apiClient.getUserProfile(userId);
  }

  Future<void> sendUserPushToken({
    @required String userId,
    @required String pushToken,
  }) async {
    await firestore
        .collection('devices')
        .doc(userId)
        .set({'token': pushToken, 'device': Platform.operatingSystem});
  }

  Stream<UserProfile> subscribeOnUser(String userId) {
    firebaseMessaging.getToken().then((token) {
      sendUserPushToken(userId: userId, pushToken: token);
    });

    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => UserProfile.fromJson(snapshot.data()))
        .map((userProfile) {
      userCache.setUserProfile(userProfile);
      return userProfile;
    });
  }
}
