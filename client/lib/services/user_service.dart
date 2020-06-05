import 'dart:io';

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
import 'package:meta/meta.dart';

class UserService {
  UserService({
    @required this.firebaseAuth,
    @required this.firestore,
  })  : assert(firebaseAuth != null),
        assert(firestore != null);

  final FirebaseAuth firebaseAuth;
  final Firestore firestore;

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
        .map((result) => mapToUserProfile(result.user))
        .asyncMap(_saveUserToFirestore)
        .transform(errorHandler);
  }

  Stream<void> logout() {
    return Stream.fromFuture(firebaseAuth.signOut());
  }

  Stream<void> register({@required RegisterRequestModel model}) {
    final errorHandler = ErrorHandler((code) {
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

  Stream<UserProfile> loginViaFacebook({@required String token}) {
    final authCredential = FacebookAuthProvider.getCredential(
      accessToken: token,
    );

    return Stream.fromFuture(firebaseAuth.signInWithCredential(authCredential))
        .transform(ErrorHandler())
        .map((authResponse) => mapToUserProfile(authResponse.user))
        .asyncMap(_saveUserToFirestore);
  }

  Stream<UserProfile> loginViaGoogle({
    @required String accessToken,
    @required String idToken,
  }) {
    final authCredential = GoogleAuthProvider.getCredential(
      accessToken: accessToken,
      idToken: idToken,
    );

    return Stream.fromFuture(firebaseAuth.signInWithCredential(authCredential))
        .transform(ErrorHandler())
        .map((authResponse) => mapToUserProfile(authResponse.user))
        .asyncMap(_saveUserToFirestore);
  }

  Stream<UserProfile> loginViaApple({
    @required String accessToken,
    @required String idToken,
    @required String firstName,
    @required String lastName,
  }) {
    const authProvider = OAuthProvider(providerId: 'apple.com');
    final credential = authProvider.getCredential(
      idToken: idToken,
      accessToken: accessToken,
    );

    final future = Future(() async {
      final response = await firebaseAuth.signInWithCredential(credential);
      final user = response.user;

      if (firstName != null && lastName != null) {
        final updateInfo = UserUpdateInfo();
        updateInfo.displayName = '$firstName $lastName';
        await user.updateProfile(updateInfo);
      }

      return firebaseAuth.currentUser();
    });

    return Stream.fromFuture(future)
        .transform(ErrorHandler())
        .map(mapToUserProfile)
        .asyncMap(_saveUserToFirestore);
  }

  Future<void> signUpUser(RegisterRequestModel model) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: model.email,
      password: model.password,
    );

    final user = await firebaseAuth.currentUser();
    final userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = model.nickName;
    await user.updateProfile(userUpdateInfo);
    await _saveUserToFirestore(mapToUserProfile(user));

    return user;
  }

  Future<SearchQueryResult<UserProfile>> searchUsers(
    String searchString,
  ) async {
    final users = await firestore
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: searchString)
        .getDocuments()
        .then(
          (snapshot) => snapshot.documents
              .map((d) => UserProfile.fromJson(d.data))
              .toList(),
        );

    return SearchQueryResult(
      searchString: searchString,
      items: users,
    );
  }

  Future<List<UserProfile>> loadProfiles(List<String> profileIds) async {
    final profiles = await Future.wait(
      profileIds.map((id) => firestore.collection('users').document(id).get()),
    );

    return profiles
        .map((snapshot) => UserProfile.fromJson(snapshot.data))
        .toList();
  }

  Future<UserProfile> _saveUserToFirestore(UserProfile user) async {
    await firestore.collection('users').document(user.userId).setData({
      'userId': user.userId,
      'userName': user.fullName,
      'avatarUrl': user.avatarUrl,
    });

    final firebaseMessaging = FirebaseMessaging();

    firebaseMessaging.getToken().then((token) {
      firestore
          .collection('devices')
          .document(user.userId)
          .setData({'token': token, 'device': Platform.operatingSystem});
    });

    return user;
  }
}
