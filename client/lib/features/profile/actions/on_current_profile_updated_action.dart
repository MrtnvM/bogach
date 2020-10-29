import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

class OnCurrentProfileUpdatedAction extends BaseAction {
  OnCurrentProfileUpdatedAction(this.userProfile);

  final UserProfile userProfile;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      s.profile.currentUser = userProfile;
    });
  }
}
