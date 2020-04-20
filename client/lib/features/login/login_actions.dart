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

class LoginViaFacebookAsyncAction extends AsyncAction<void> {
  LoginViaFacebookAsyncAction({@material.required this.token})
      : assert(token != null);

  final String token;
}

class LoginViaGoogleAsyncAction extends AsyncAction<void> {
  LoginViaGoogleAsyncAction({
    @material.required this.token,
    @material.required this.idToken,
  })  : assert(token != null),
        assert(idToken != null);

  final String token;
  final String idToken;
}
