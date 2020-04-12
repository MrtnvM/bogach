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

  Observable<void> login({
    @required String email,
    @required String password,
  }) {
    return Observable.fromFuture(_firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .doOnData((response) =>
            tokenStorage.saveTokens(accessToken: response.user.uid))
        .cast<void>()
        .onErrorResume((error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_NETWORK_REQUEST_FAILED') {
          return Observable.error(NetworkConnectionException(null));
        } else if (error.code == 'ERROR_USER_NOT_FOUND') {
          return Observable.error(const InvalidCredentialsException());
        }
      }
      return Observable.error(error);
    });
  }

  Observable<void> logout() {
    return Observable.just(_firebaseAuth.signOut());
  }

  Observable<void> register({@required RegisterRequestModel model}) {
    return Observable.fromFuture(signUpUser(model)).onErrorResume((error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          return Observable.error(const EmailHasBeenTakenException());
        }
      }
      return Observable.error(error);
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
