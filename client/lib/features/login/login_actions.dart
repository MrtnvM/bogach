import 'package:cash_flow/models/state/user/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_platform_core/flutter_platform_core.dart';

class LoginAsyncAction extends AsyncAction<void> {
  LoginAsyncAction({
    @material.required this.email,
    @material.required this.password,
  })  : assert(email != null),
        assert(password != null);

  final String email;
  final String password;
}

class LogoutAsyncAction extends AsyncAction<void> {
  LogoutAsyncAction();
}

class LoginViaFacebookAsyncAction extends AsyncAction<CurrentUser> {
  LoginViaFacebookAsyncAction({@material.required this.token})
      : assert(token != null);

  final String token;
}

class LoginViaGoogleAsyncAction extends AsyncAction<CurrentUser> {
  LoginViaGoogleAsyncAction({
    @material.required this.token,
    @material.required this.idToken,
  })  : assert(token != null),
        assert(idToken != null);

  final String token;
  final String idToken;
}

class SetCurrentUserAction extends Action {
  SetCurrentUserAction({@material.required this.user});

  final FirebaseUser user;
}
