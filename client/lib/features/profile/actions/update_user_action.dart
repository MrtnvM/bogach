import 'dart:async';
import 'dart:io';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UpdateUserAction extends BaseAction {
  UpdateUserAction({
    @required this.userId,
    this.fullName,
    this.avatar,
  });

  final String userId;
  final String fullName;
  final File avatar;

  @override
  Operation get operationKey => Operation.updateUser;

  @override
  Future<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    await userService.updateUser(
      userId: userId,
      newName: fullName,
      newAvatar: avatar,
    );

    return null;
  }
}
