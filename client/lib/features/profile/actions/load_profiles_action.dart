import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class LoadProfilesAction extends BaseAction {
  LoadProfilesAction({@required this.ids}) : assert(ids != null);

  final List<String> ids;

  @override
  bool abortDispatch() => ids.isEmpty;

  @override
  Future<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    final profiles = await userService.loadProfiles(ids);

    return state.rebuild((s) {
      final userProfiles = [...s.multiplayer.userProfiles.items, ...profiles];
      s.multiplayer.userProfiles = StoreList<UserProfile>(userProfiles);
    });
  }
}
