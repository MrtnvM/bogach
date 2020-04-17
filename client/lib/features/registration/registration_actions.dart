import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_platform_core/flutter_platform_core.dart';

class RegisterAsyncAction extends AsyncAction<void> {
  RegisterAsyncAction({
    @material.required this.model,
  }) : assert(model != null);

  final RegisterRequestModel model;
}
