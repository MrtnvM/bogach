import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/models/domain/user/online/online_profile.dart';
import 'package:cash_flow/services/multiplayer_service.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class SetUserOnlineAction extends BaseAction {
  SetUserOnlineAction({@required this.user}) : assert(user != null);

  final OnlineProfile user;

  @override
  Operation get operationKey => Operation.setOnline;

  @override
  FutureOr<AppState> reduce() async {
    final multiplayerService = GetIt.I.get<MultiplayerService>();

    try {
      final onlineProfiles = await multiplayerService.setUserOnline(user);

      return state.rebuild((b) {
        return b.multiplayer.onlineProfiles = onlineProfiles;
      });
    } catch (error) {
      Logger.e(error);
      return null;
    }
  }
}
