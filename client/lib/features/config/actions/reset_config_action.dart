import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/config/config_state.dart';

class ResetConfigAction extends BaseAction {
  @override
  AppState reduce() {
    return state.rebuild((s) {
      s.config = ConfigState.initial();
    });
  }
}
