library app_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/features/login/login_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'app_state.g.dart';

abstract class AppState
    implements Built<AppState, AppStateBuilder>, GlobalState {
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  AppState._();

  LoginState get login;

  static AppState initial() {
    return AppState(
      (b) => b..login = LoginState.initial().toBuilder(),
    );
  }
}
