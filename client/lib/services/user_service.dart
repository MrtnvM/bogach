import 'dart:io';

import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/cache/user_cache.dart';
import 'package:cash_flow/core/utils/mappers/current_user_mappers.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

const _defaultUserName = 'Anonymous';

class UserService {
  UserService({
    @required this.firebaseAuth,
    @required this.firestore,
    @required this.cloudStorage,
    @required this.firebaseMessaging,
    @required this.userCache,
    @required this.apiClient,
  })  : assert(firebaseAuth != null),
        assert(firestore != null);

  static int currentlyUsedProfileVersion = 3;

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage cloudStorage;
  final FirebaseMessaging firebaseMessaging;
  final UserCache userCache;
  final CashFlowApiClient apiClient;

  Future<UserProfile> login({
    @required String email,
    @required String password,
  }) {
    return firebaseAuth
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((result) => _createUserIfNeed(result.user))
        .catchError(recordError);
  }

  Future<void> logout() async {
    await userCache.deleteUserProfile();
    await firebaseAuth.signOut();
  }

  Future<UserProfile> register({@required RegisterRequestModel model}) {
    return signUpUser(model).catchError(recordError);
  }

  Future<void> resetPassword({@required String email}) {
    return firebaseAuth
        .sendPasswordResetEmail(email: email)
        .catchError(recordError);
  }

  Future<UserProfile> loginViaFacebook({@required String token}) {
    return firebaseAuth
        .signInWithCredential(FacebookAuthProvider.credential(token))
        .then((response) => _createUserIfNeed(response.user))
        .catchError(recordError);
  }

  Future<UserProfile> loginViaGoogle({
    @required String accessToken,
    @required String idToken,
  }) {
    return firebaseAuth
        .signInWithCredential(GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: idToken,
        ))
        .then((response) => _createUserIfNeed(response.user))
        .catchError(recordError);
  }

  Future<UserProfile> loginViaApple({
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

    return loginRequest.then(_createUserIfNeed).catchError(recordError);
  }

  Future<void> signUpUser(RegisterRequestModel model) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: model.email,
      password: model.password,
    );

    final user = firebaseAuth.currentUser;
    await user.updateProfile(displayName: model.nickName);
    await _createUserIfNeed(user);

    return Future.value();
  }

  Future<List<UserProfile>> loadProfiles(List<String> profileIds) async {
    final profiles = await Future.wait(
      profileIds.map((id) => firestore.collection('users').doc(id).get()),
    ).catchError(recordError);

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

  Future<UserProfile> loadUserFromServer(userId) {
    return apiClient.getUserProfile(userId).catchError(recordError);
  }

  Future<void> sendUserPushToken({
    @required String userId,
    @required String pushToken,
  }) async {
    await firestore.collection('devices').doc(userId).set({
      'token': pushToken,
      'device': Platform.operatingSystem
    }).catchError(recordError);
  }

  Future<void> saveUserProfileInCache(UserProfile userProfile) {
    return userCache.setUserProfile(userProfile);
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
      saveUserProfileInCache(userProfile);
      return userProfile;
    }).doOnData((profile) {
      if (profile.profileVersion < currentlyUsedProfileVersion) {
        /// Requesting user profile through the server request will
        /// auto-migrate it to the newer version
        apiClient.getUserProfile(userId).catchError((err) => null);
      }
    }).handleError(recordError, test: (e) => true);
  }

  Future<void> updateUser({
    @required String userId,
    String newName,
    File newAvatar,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkConnectionException(null);
    }

    final newInfo = <String, dynamic>{};

    if (newName != null) {
      newInfo.addAll({'userName': newName});
    }

    if (newAvatar != null) {
      final url = await cloudStorage
          .ref()
          .child('users/$userId/avatar')
          .putFile(newAvatar)
          .then((task) => task.ref.getDownloadURL())
          .catchError(recordError);

      newInfo.addAll({'avatarUrl': url});
    }

    if (newInfo.isEmpty) {
      return;
    }

    return firestore
        .collection('users')
        .doc(userId)
        .update(newInfo)
        .catchError(recordError);
  }

  Future<UserProfile> _createUserIfNeed(User user) async {
    final userId = user.uid;
    await userCache.deleteUserProfile();

    /// Requesting user profile through the server request will
    /// auto-migrate it to the newer version
    final serverProfile = await apiClient //
        .getUserProfile(userId)
        .catchError((err) => null);

    var updatedUser = serverProfile;

    if (serverProfile == null) {
      updatedUser = mapToUserProfile(user);
    }

    if (updatedUser.fullName?.isEmpty ?? true) {
      updatedUser = updatedUser.copyWith(
        fullName: _defaultUserName,
      );
    }

    if (updatedUser.avatarUrl?.isEmpty ?? true) {
      updatedUser = updatedUser.copyWith(
        avatarUrl: Images.defaultAvatarUrl,
      );
    }

    if (serverProfile != updatedUser) {
      final userData = updatedUser.toJson();
      await firestore.collection('users').doc(userId).set(userData);
    }

    await userCache.setUserProfile(updatedUser);
    return updatedUser;
  }

  Future<void> addFriends(String userId, List<String> usersAddToFriends) {
    return apiClient
        .addFriends(userId, usersAddToFriends)
        .catchError(recordError);
  }

  Future<void> removeFromFriends({
    @required String userId,
    @required String removedFriendId,
  }) {
    return apiClient
        .removeFromFriends(userId: userId, removedFriendId: removedFriendId)
        .catchError(recordError);
  }
}
