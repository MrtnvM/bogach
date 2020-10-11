import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_state.dart';

T useConfig<T>(T Function(ConfigState) converter) {
  return useGlobalState((s) => converter(s.config));
}
