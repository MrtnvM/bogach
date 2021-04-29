library register_request_model;

import 'package:built_value/built_value.dart';

part 'register_request_model.g.dart';

abstract class RegisterRequestModel
    implements Built<RegisterRequestModel, RegisterRequestModelBuilder> {
  factory RegisterRequestModel(
          [void Function(RegisterRequestModelBuilder b)? updates]) =
      _$RegisterRequestModel;

  RegisterRequestModel._();

  String? get nickName;

  String? get email;

  String? get password;

  String? get repeatPassword;
}
