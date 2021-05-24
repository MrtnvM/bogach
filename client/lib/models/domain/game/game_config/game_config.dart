import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_config.freezed.dart';
part 'game_config.g.dart';

@freezed
class GameConfig with _$GameConfig {
  factory GameConfig({
    required int initialCash,
    required String gameTemplateId,
    String? level,
    int? monthLimit,
  }) = _GameConfig;

  factory GameConfig.fromJson(Map<String, dynamic> json) =>
      _$GameConfigFromJson(json);
}
