import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

String useUserId() {
  return useGlobalState((s) => s.profile.currentUser.userId);
}

UserProfile useCurrentUser() {
  return useGlobalState((s) => s.profile.currentUser);
}

List<UserProfile> useCurrentUserFriends() {
  return [];
}
