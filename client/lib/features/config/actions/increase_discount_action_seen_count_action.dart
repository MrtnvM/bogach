import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/services/config_service.dart';
import 'package:get_it/get_it.dart';

class IncreaseDiscountActionSeenCountAction extends BaseAction {
  @override
  Future<AppState> reduce() async {
    final configService = GetIt.I.get<ConfigService>();

    final config = state.config.copyWith(
      discountActionSeenCount: state.config.discountActionSeenCount + 1,
    );

    await configService.saveConfig(config);

    return state.rebuild((s) {
      s.config = config;
    });
  }
}
