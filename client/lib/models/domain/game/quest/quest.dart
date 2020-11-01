import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

@freezed
abstract class Quest with _$Quest implements StoreListItem {
  factory Quest({
    @required String id,
    @required String name,
    @required String description,
    @required String icon,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
