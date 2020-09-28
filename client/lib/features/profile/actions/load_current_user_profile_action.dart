import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/profile/actions/set_current_user_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class LoadCurrentUserProfileAction extends BaseAction {
  @override
  FutureOr<AppState> reduce() async {
    final userId = state.profile.currentUser?.id;

    if (userId == null) {
      return null;
    }

    final userService = GetIt.I.get<UserService>();

    final currentUser = await performRequest(
      userService.loadProfile(userId),
      NetworkRequest.loadCurrentUserProfile,
    );

    dispatch(SetCurrentUserAction(currentUser));

    return null;
  }
}
