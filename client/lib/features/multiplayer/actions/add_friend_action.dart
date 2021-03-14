import 'dart:async';
import 'dart:math';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class AddFriendAction extends BaseAction {
  AddFriendAction({
    @required this.userId,
    @required this.userAddToFriendId,
    this.retryCount = 0,
  })  : assert(userId != null),
        assert(userAddToFriendId != null);

  final String userId;
  final String userAddToFriendId;
  final int retryCount;

  static const int _retryDelaySeconds = 2;

  @override
  Operation get operationKey => Operation.addFriend;

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();
    final usersAddToFriendsStorage = GetIt.I.get<UsersAddToFriendsStorage>();

    await usersAddToFriendsStorage.addUserId(userAddToFriendId);
    final addToFriendsIds = usersAddToFriendsStorage.getUsersAddToFriends();

    await userService.addFriends(userId, addToFriendsIds).then((result) {
      usersAddToFriendsStorage.deleteUserIds(addToFriendsIds);
    }, onError: (error) async {
      Logger.e('Sending add friends request error', error);

      final action = AddFriendAction(
        userId: userId,
        userAddToFriendId: userAddToFriendId,
        retryCount: retryCount + 1,
      );
      await _resendActionWithDelay(action);
    });

    return state;
  }

  Future<void> _resendActionWithDelay(AddFriendAction action) async {
    final delayDuration = Duration(
      seconds: pow(_retryDelaySeconds, action.retryCount),
    );

    Future.delayed(delayDuration).then((_) => dispatch(action));
  }
}
