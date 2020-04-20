import 'package:cash_flow/core/utils/mappers/current_user_mappers.dart';
import 'package:cash_flow/models/network/errors/email_has_been_taken_exception.dart';
import 'package:cash_flow/models/network/errors/invalid_credentials_exception.dart';
import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:cash_flow/models/state/user/current_user.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class UserService {
  UserService();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<void> login({
    @required String email,
    @required String password,
  }) {
    return Stream.fromFuture(_firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).cast<void>().transform(ErrorHandler((code) {
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

  Stream<CurrentUser> loginViaFacebook({@required String token}) {
    final authCredential =
        FacebookAuthProvider.getCredential(accessToken: token);

    return Stream.fromFuture(_firebaseAuth.signInWithCredential(authCredential))
        .transform(ErrorHandler())
        .map(mapToCurrentUser);
  }

  Stream<CurrentUser> loginViaGoogle({
    @required String token,
    @required String idToken,
  }) {
    final authCredential = GoogleAuthProvider.getCredential(
      accessToken: token,
      idToken: idToken,
    );

    return Stream.fromFuture(_firebaseAuth.signInWithCredential(authCredential))
        .transform(ErrorHandler())
        .map(mapToCurrentUser);
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
