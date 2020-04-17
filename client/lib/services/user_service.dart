import 'package:cash_flow/models/network/errors/email_has_been_taken_exception.dart';
import 'package:cash_flow/models/network/errors/invalid_credentials_exception.dart';
import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  UserService({
    @required this.tokenStorage,
  });

  final TokenStorage tokenStorage;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<void> login({
    @required String email,
    @required String password,
  }) {
    return Stream.fromFuture(_firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .doOnData((response) =>
            tokenStorage.saveTokens(accessToken: response.user.uid))
        .cast<void>()
        .onErrorResume((error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_NETWORK_REQUEST_FAILED') {
          return Stream.error(NetworkConnectionException(null));
        } else if (error.code == 'ERROR_USER_NOT_FOUND') {
          return Stream.error(const InvalidCredentialsException());
        }
      }
      return Stream.error(error);
    });
  }

  Stream<void> logout() {
    return Stream.value(_firebaseAuth.signOut());
  }

  Stream<void> register({@required RegisterRequestModel model}) {
    return Stream.fromFuture(signUpUser(model)).onErrorResume((error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          return Stream.error(const EmailHasBeenTakenException());
        }
      }
      return Stream.error(error);
    });
  }

  Future<void> signUpUser(RegisterRequestModel model) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: model.email,
      password: model.password,
    );

    final user = await _firebaseAuth.currentUser();
    final userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = model.nickName;
    await user.updateProfile(userUpdateInfo);

    return user;
  }
}
