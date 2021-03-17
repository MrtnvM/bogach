import 'package:shared_preferences/shared_preferences.dart';

class UsersAddToFriendsStorage {
  const UsersAddToFriendsStorage({this.preferences});

  final SharedPreferences preferences;
  static const _usersAddToFriendsKey = 'users_add_to_friends_key';

  List<String> getUsersAddToFriends() {
    final usersAddToFriends = preferences.getStringList(_usersAddToFriendsKey);
    if (usersAddToFriends == null) {
      return List.empty();
    }

    return usersAddToFriends;
  }

  Future<void> addUserId(String userId) async {
    final friends = getUsersAddToFriends();
    final newFriends = _addUniqueFriend(friends, userId);
    await preferences.setStringList(_usersAddToFriendsKey, newFriends);
  }

  List<String> _addUniqueFriend(List<String> currentFriends, String userId) {
    if (!currentFriends.contains(userId)) {
      return [
        ...currentFriends,
        userId,
      ];
    } else {
      return currentFriends;
    }
  }

  Future<void> deleteUserIds(List<String> userIdsToDelete) async {
    final friends = getUsersAddToFriends();
    final newFriends =
        friends.where((userId) => !userIdsToDelete.contains(userId)).toList();

    await preferences.setStringList(_usersAddToFriendsKey, newFriends);
  }

  Future<void> clear() async {
    await preferences.setStringList(_usersAddToFriendsKey, List.empty());
  }
}
