import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/login/login_reducer.dart';
import 'package:cash_flow/features/quests/possessions_reducer.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class AppReducer extends Reducer<AppState> {
  @override
  AppState reduce(AppState state, Action action) {
    return state.rebuild(
      (AppStateBuilder s) {
        s.login = loginReducer.reduce(state.login, action).toBuilder();
        s.possessions =
            possessionsReducer.reduce(state.possessions, action).toBuilder();
      },
    );
  }
}
