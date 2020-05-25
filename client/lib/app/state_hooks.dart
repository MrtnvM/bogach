import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/user/current_user.dart';

String useUserId() {
  return useGlobalState((s) => s.login.currentUser.userId);
}

CurrentUser useCurrentUser() {
  return useGlobalState((s) => s.login.currentUser);
}
