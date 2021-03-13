import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class AddFriendAction extends BaseAction {
  AddFriendAction(this.firstUserId, this.secondUserId)
      : assert(firstUserId != null),
        assert(secondUserId != null);

  final String firstUserId;
  final String secondUserId;

  @override
  Operation get operationKey => Operation.addFriend;

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();
    await userService.addFriend(firstUserId, secondUserId);

    return state;
  }
}
