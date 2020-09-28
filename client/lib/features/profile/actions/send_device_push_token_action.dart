import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class SendDevicePushTokenAction extends BaseAction {
  SendDevicePushTokenAction({
    @required this.userId,
    @required this.pushToken,
  })  : assert(userId != null),
        assert(pushToken != null);

  final String userId;
  final String pushToken;

  @override
  NetworkRequest get operationKey => NetworkRequest.sendDevicePushToken;

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    await userService.sendUserPushToken(
      userId: userId,
      pushToken: pushToken,
    );

    return null;
  }
}
