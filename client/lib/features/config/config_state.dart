import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_state.freezed.dart';
part 'config_state.g.dart';

@freezed
class ConfigState with _$ConfigState {
  factory ConfigState({
    required bool isGameboardTutorialPassed,
    required bool isOnline,
    @JsonKey(defaultValue: 0) required int discountActionSeenCount,
  }) = _ConfigState;

  factory ConfigState.fromJson(Map<String, dynamic> json) =>
      _$ConfigStateFromJson(json);

  static ConfigState initial() {
    return ConfigState(
      isGameboardTutorialPassed: false,
      isOnline: true,
      discountActionSeenCount: 0,
    );
  }
}
