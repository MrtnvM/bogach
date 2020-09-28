import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class QueryUserProfilesAction extends BaseAction {
  QueryUserProfilesAction([this.query]);

  final String query;

  @override
  NetworkRequest get operationKey => NetworkRequest.queryUserProfiles;

  @override
  FutureOr<AppState> reduce() async {
    final userService = GetIt.I.get<UserService>();

    final result = await userService.searchUsers(query);

    return state.rebuild((s) {
      s.multiplayer.userProfiles.updateList(result.items);
      s.multiplayer.userProfilesQuery = result;
    });
  }
}
