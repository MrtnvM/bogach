import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/profile/actions/set_current_user_action.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class UpdateCurrentQuestIndexAction extends BaseAction {
  UpdateCurrentQuestIndexAction(this.newQuestIndex);

  final int newQuestIndex;

  @override
  FutureOr<AppState> reduce() {
    final userService = GetIt.I.get<UserService>();

    final updatedProfile = userService.updateCurrentQuestIndex(
      newQuestIndex,
    );

    dispatch(SetCurrentUserAction(updatedProfile));

    return null;
  }
}
