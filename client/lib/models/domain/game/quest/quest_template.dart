import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_template.freezed.dart';

part 'quest_template.g.dart';

@freezed
abstract class QuestTemplate with _$QuestTemplate implements StoreListItem {
  factory QuestTemplate({
    @required String id,
    @required String name,
  }) = _QuestTemplate;

  factory QuestTemplate.fromJson(Map<String, dynamic> json) =>
      _$QuestTemplateFromJson(json);
}
