import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_state.freezed.dart';
part 'config_state.g.dart';

@freezed
abstract class ConfigState with _$ConfigState {
  factory ConfigState({
    bool isGameboardTutorialPassed,
  }) = _ConfigState;

  factory ConfigState.fromJson(Map<String, dynamic> json) =>
      _$ConfigStateFromJson(json);

  static ConfigState initial() {
    return ConfigState(
      isGameboardTutorialPassed: false,
    );
  }
}
