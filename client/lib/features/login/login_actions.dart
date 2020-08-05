import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class LogoutAsyncAction extends AsyncAction<void> {
  LogoutAsyncAction();
}

class LoginViaFacebookAsyncAction extends AsyncAction<UserProfile> {
  LoginViaFacebookAsyncAction({@required this.token}) : assert(token != null);

  final String token;
}

class LoginViaGoogleAsyncAction extends AsyncAction<UserProfile> {
  LoginViaGoogleAsyncAction({
    @required this.accessToken,
    @required this.idToken,
  })  : assert(accessToken != null),
        assert(idToken != null);

  final String accessToken;
  final String idToken;
}

class LoginViaAppleAsyncAction extends AsyncAction<UserProfile> {
  LoginViaAppleAsyncAction({
    @required this.accessToken,
    @required this.idToken,
    @required this.firstName,
    @required this.lastName,
  })  : assert(accessToken != null),
        assert(idToken != null);

  final String accessToken;
  final String idToken;
  final String firstName;
  final String lastName;
}

class SetCurrentUserAction extends Action {
  SetCurrentUserAction({@required this.user});

  final FirebaseUser user;
}

class SendDevicePushTokenAsyncAction extends AsyncAction {
  SendDevicePushTokenAsyncAction({
    @required this.userId,
    @required this.pushToken,
  })  : assert(userId != null),
        assert(pushToken != null);

  final String userId;
  final String pushToken;
}
