import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

String useUserId() {
  return useGlobalState((s) => s.profile.currentUser.userId);
}

UserProfile useCurrentUser() {
  return useGlobalState((s) => s.profile.currentUser);
}

const tempAvatarUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:'
    'ANd9GcTbIjEd4SK66CgF5gGue74imvw60UtXG-MpTiKEPnRDV_-X4ipr5I6sewb'
    'BCcLPqZMLtLw&usqp=CAU';

List<UserProfile> useCurrentUserFriends() {
  return [
    UserProfile(
      userId: '0',
      fullName: 'Простодлиннаяфамилия Имя',
      avatarUrl: tempAvatarUrl,
      status: 'online',
    ),
    UserProfile(
      userId: '1',
      fullName: 'Простодлиннаяфамилия Имя',
      avatarUrl: tempAvatarUrl,
      status: 'offline',
    ),
    UserProfile(
      userId: '2',
      fullName: 'Фам Имя',
      avatarUrl: tempAvatarUrl,
      status: 'offline',
    ),
    UserProfile(
      userId: '3',
      fullName: 'Фамилия Имя',
      avatarUrl: tempAvatarUrl,
      status: 'online',
    ),
    UserProfile(
      userId: '4',
      fullName: 'Фамилия Имядлинноеочень',
      avatarUrl: tempAvatarUrl,
      status: 'offline',
    ),
  ];
}
