import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/services/config_service.dart';
import 'package:get_it/get_it.dart';

class LoadConfigAction extends BaseAction {
  @override
  FutureOr<AppState> reduce() async {
    final configService = GetIt.I.get<ConfigService>();

    final config = await configService.loadConfig();

    return state.rebuild((s) {
      s.config = config;
    });
  }
}
