import 'package:cash_flow/models/network/errors/email_has_been_taken_exception.dart';
import 'package:cash_flow/models/network/errors/invalid_credentials_exception.dart';
import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        .transform(ErrorHandler((code) {
      if (code == 'ERROR_USER_NOT_FOUND') {
        return const InvalidCredentialsException();
      }

      return null;
    }));
  }

  Stream<void> logout() {
    return Stream.value(_firebaseAuth.signOut());
  }

  Stream<void> register({@required RegisterRequestModel model}) {
    return Stream.fromFuture(signUpUser(model)).transform(ErrorHandler((code) {
      if (code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return const EmailHasBeenTakenException();
      }

      return null;
    }));
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
