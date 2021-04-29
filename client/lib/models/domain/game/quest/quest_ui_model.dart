import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class QuestUiModel implements StoreListItem {
  const QuestUiModel({
    required this.quest,
    required this.isAvailable,
  });

  final Quest quest;
  final bool isAvailable;

  @override
  Object get id => quest.id;
}
