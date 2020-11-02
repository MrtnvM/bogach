library new_game_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'new_game_state.g.dart';

abstract class NewGameState
    implements Built<NewGameState, NewGameStateBuilder> {
  factory NewGameState([void Function(NewGameStateBuilder b) updates]) =
      _$NewGameState;

  NewGameState._();

  StoreList<GameTemplate> get gameTemplates;
  StoreList<Quest> get quests;

  @nullable
  String get newGameId;

  static NewGameState initial() => NewGameState(
        (b) => b
          ..gameTemplates = StoreList<GameTemplate>()
          ..quests = StoreList<Quest>()
          ..newGameId = null,
      );
}
