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
