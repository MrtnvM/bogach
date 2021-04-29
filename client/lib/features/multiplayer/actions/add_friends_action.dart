import 'dart:async';
import 'dart:math';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:get_it/get_it.dart';

class AddFriendsAction extends BaseAction {
  // TODO(Team): может не отправиться значение, если пользователь перешел
  // по динамик линке, мы пытались отправить запрос на бек, не смогли,
  // а затем пользователь закрыл приложение. Запрос отправится только если
  // пользователь перейдет по динамик линке еще раз
  AddFriendsAction({
    required this.userId,
    this.retryCount = 0,
  });

  final String userId;
  final int retryCount;

  static const int _retryDelaySeconds = 2;

  @override
  Operation get operationKey => Operation.addFriend;

  @override
  Future<AppState?> reduce() async {
    final userService = GetIt.I.get<UserService>();
    final usersAddToFriendsStorage = GetIt.I.get<UsersAddToFriendsStorage>();

    final addToFriendsIds = usersAddToFriendsStorage.getUsersAddToFriends();
    if (addToFriendsIds.isEmpty) {
      return state;
    }

    await userService.addFriends(userId, addToFriendsIds).then((result) {
      usersAddToFriendsStorage.deleteUserIds(addToFriendsIds);
    }, onError: (error) async {
      Logger.e('Sending add friends request error', error);

      final action = AddFriendsAction(
        userId: userId,
        retryCount: retryCount + 1,
      );

      await _resendActionWithDelay(action);
    });

    return null;
  }

  Future<void> _resendActionWithDelay(AddFriendsAction action) async {
    final delayDuration = Duration(
      seconds: pow(_retryDelaySeconds, action.retryCount) as int,
    );

    Future.delayed(delayDuration).then((_) => dispatch(action));
  }
}
