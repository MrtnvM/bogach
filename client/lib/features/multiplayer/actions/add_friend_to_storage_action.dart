import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:get_it/get_it.dart';

class AddFriendToStorageAction extends BaseAction {
  AddFriendToStorageAction({required this.userAddToFriendId});

  final String userAddToFriendId;

  @override
  Operation get operationKey => Operation.addFriendToStorage;

  @override
  Future<AppState?> reduce() async {
    final usersAddToFriendsStorage = GetIt.I.get<UsersAddToFriendsStorage>();
    await usersAddToFriendsStorage.addUserId(userAddToFriendId);
    return null;
  }
}
