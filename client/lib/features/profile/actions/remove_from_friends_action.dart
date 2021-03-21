import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class RemoveFromFriendsAciton extends BaseAction {
  RemoveFromFriendsAciton(this.removedFriendId);

  final String removedFriendId;

  @override
  Operation get operationKey => Operation.removeFromFriends;

  @override
  Future<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    final userId = state.profile.currentUser.id;

    await userService.removeFromFriends(
      userId: userId,
      removedFriendId: removedFriendId,
    );

    return null;
  }
}
