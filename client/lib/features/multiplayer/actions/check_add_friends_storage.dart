import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/cache/add_friends_storage.dart';
import 'package:cash_flow/features/multiplayer/actions/add_friends_action.dart';
import 'package:get_it/get_it.dart';

class CheckAddFriendsStorage extends BaseAction {
  @override
  Operation get operationKey => Operation.addFriendToStorage;

  @override
  Future<AppState> reduce() async {
    final usersAddToFriendsStorage = GetIt.I.get<UsersAddToFriendsStorage>();
    final usersToAdd = usersAddToFriendsStorage.getUsersAddToFriends();
    final userId = store.state.profile.currentUser.id;

    if (usersToAdd.isNotEmpty) {
      dispatch(AddFriendsAction(userId: userId));
    }

    return null;
  }
}
