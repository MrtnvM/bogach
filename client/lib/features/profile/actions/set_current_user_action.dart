import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

class SetCurrentUserAction extends BaseAction {
  SetCurrentUserAction(this.user);

  final UserProfile? user;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      s.profile.currentUser = user;
    });
  }

  @override
  String toString() {
    return '${super.toString()} (${user?.userId})';
  }
}
