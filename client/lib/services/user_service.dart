import 'dart:io';

import 'package:cash_flow/cache/user_cache.dart';
import 'package:cash_flow/core/utils/mappers/current_user_mappers.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/core/search_query_result.dart';
import 'package:cash_flow/models/network/errors/email_has_been_taken_exception.dart';
import 'package:cash_flow/models/network/errors/invalid_credentials_exception.dart';
import 'package:cash_flow/models/network/errors/invalid_email_exception.dart';
import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:meta/meta.dart';

class UserService {
  UserService({
    @required this.firebaseAuth,
    @required this.firestore,
    @required this.firebaseMessaging,
    @required this.userCache,
  })  : assert(firebaseAuth != null),
        assert(firestore != null);

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseMessaging firebaseMessaging;
  final UserCache userCache;

  Stream<UserProfile> login({
    @required String email,
    @required String password,
  }) {
    final errorHandler = ErrorHandler<UserProfile>((code) {
      if (code == 'ERROR_USER_NOT_FOUND') {
        return const InvalidCredentialsException();
      }

      return null;
    });

    final logInOperation = firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return Stream.fromFuture(logInOperation)
        .asyncMap((result) => _getUpdatedUser(result.user))
        .transform(errorHandler);
  }

  Future<void> logout() async {
    userCache.deleteUserProfile();
    await firebaseAuth.signOut();
  }

  Stream<UserProfile> register({@required RegisterRequestModel model}) {
    final errorHandler = ErrorHandler<UserProfile>((code) {
      if (code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return const EmailHasBeenTakenException();
      }

      return null;
    });

    return Stream.fromFuture(signUpUser(model)).transform(errorHandler);
  }

  Stream<void> resetPassword({@required String email}) {
    final errorHandler = ErrorHandler((code) {
      if (code == 'ERROR_USER_NOT_FOUND') {
        return const InvalidEmailException();
      }

      return null;
    });

    return Stream.fromFuture(firebaseAuth.sendPasswordResetEmail(email: email))
        .transform(errorHandler);
  }

  Future<UserProfile> loginViaFacebook({@required String token}) {
    final authCredential = FacebookAuthProvider.credential(token);

    return Stream.fromFuture(firebaseAuth.signInWithCredential(authCredential))
        .transform(ErrorHandler())
        .asyncMap((response) => _getUpdatedUser(response.user))
        .first;
  }

  Future<UserProfile> loginViaGoogle({
    @required String accessToken,
    @required String idToken,
  }) {
    final authCredential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    return Stream.fromFuture(firebaseAuth.signInWithCredential(authCredential))
        .transform(ErrorHandler())
        .asyncMap((authResponse) => _getUpdatedUser(authResponse.user))
        .first;
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

    final future = Future(() async {
      final response = await firebaseAuth.signInWithCredential(credential);
      final user = response.user;

      if (firstName != null && lastName != null) {
        await user.updateProfile(displayName: '$firstName $lastName');
      }

      return firebaseAuth.currentUser;
    });

    return Stream.fromFuture(future)
        .transform(ErrorHandler())
        .asyncMap(_getUpdatedUser)
        .first;
  }

  Future<UserProfile> signUpUser(RegisterRequestModel model) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: model.email,
      password: model.password,
    );

    final user = firebaseAuth.currentUser;
    await user.updateProfile(displayName: model.nickName);
    final updatedUser = _getUpdatedUser(user);

    return updatedUser;
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

  Future<UserProfile> loadProfile(String userId) async {
    final snapshot = await firestore.collection('users').doc(userId).get();
    if (snapshot?.data == null) {
      return null;
    }

    final profile = UserProfile.fromJson(snapshot.data());
    final currentUserProfile = userCache.getUserProfile();
    if (currentUserProfile?.id == profile.id) {
      userCache.setUserProfile(profile);
    }

    return profile;
  }

  Future<List<UserProfile>> loadProfiles(List<String> profileIds) async {
    final profiles = await Future.wait(
      profileIds.map((id) => firestore.collection('users').doc(id).get()),
    );

    final emptyProfiles = profiles //
        .where((p) => p.data == null)
        .map((p) => p.id);

    Logger.d('WARNING: not found profiles with IDs: $emptyProfiles');

    return profiles
        .where((p) => p.data != null)
        .map((snapshot) => UserProfile.fromJson(snapshot.data()))
        .toList();
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

  UserProfile updateCurrentQuestIndex(int newQuestIndex) {
    final userProfile = userCache.getUserProfile();
    if (userProfile == null) {
      return null;
    }

    final updatedProfile = userProfile.copyWith(
      currentQuestIndex: newQuestIndex,
    );

    userCache.setUserProfile(updatedProfile);
    return updatedProfile;
  }

  Future<UserProfile> _getUpdatedUser(User user) async {
    final userId = user.uid;
    final cachedUserProfile = userCache.getUserProfile();
    final firestoreUser = await loadProfile(userId);
    var updatedUser = firestoreUser;

    if (firestoreUser != null) {
      updatedUser = firestoreUser.copyWith(
        fullName: user.displayName,
        avatarUrl: user.photoURL,
      );
    }

    if (cachedUserProfile == null && updatedUser == null) {
      updatedUser = mapToUserProfile(user);
    }

    if (cachedUserProfile != updatedUser) {
      final userData = updatedUser.toJson();
      await firestore.collection('users').doc(userId).set(userData);
      userCache.setUserProfile(updatedUser);
    }

    firebaseMessaging.getToken().then((token) {
      sendUserPushToken(userId: userId, pushToken: token);
    });

    return updatedUser;
  }
}
