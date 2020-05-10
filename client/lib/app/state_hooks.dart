import 'package:cash_flow/core/hooks/global_state_hook.dart';

String useUserId() {
  return useGlobalState((s) => s.login.currentUser.userId);
}
