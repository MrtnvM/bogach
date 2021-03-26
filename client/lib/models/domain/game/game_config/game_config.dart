import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_config.freezed.dart';
part 'game_config.g.dart';

@freezed
abstract class GameConfig with _$GameConfig {
  factory GameConfig({
    String level,
    int monthLimit,
    int initialCash,
    String gameTemplateId,
  }) = _GameConfig;

  factory GameConfig.fromJson(Map<String, dynamic> json) =>
      _$GameConfigFromJson(json);
}
