import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_level.freezed.dart';
part 'game_level.g.dart';

@freezed
abstract class GameLevel with _$GameLevel implements StoreListItem {
  factory GameLevel({
    @required String id,
    @required String name,
    @required String icon,
  }) = _GameLevel;

  factory GameLevel.fromJson(Map<String, dynamic> json) =>
      _$GameLevelFromJson(json);
}
