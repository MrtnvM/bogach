import 'package:cash_flow/app/app_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class AppReducer extends Reducer<AppState> {
  @override
  AppState reduce(AppState state, Action action) {
    return state.rebuild(
      (AppStateBuilder s) {},
    );
  }
}
