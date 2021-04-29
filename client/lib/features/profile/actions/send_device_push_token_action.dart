import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class SendDevicePushTokenAction extends BaseAction {
  SendDevicePushTokenAction({
    required this.userId,
    required this.pushToken,
  });

  final String userId;
  final String pushToken;

  @override
  Operation get operationKey => Operation.sendDevicePushToken;

  @override
  Future<AppState?> reduce() async {
    final userService = GetIt.I.get<UserService>();

    await userService.sendUserPushToken(
      userId: userId,
      pushToken: pushToken,
    );

    return null;
  }
}
