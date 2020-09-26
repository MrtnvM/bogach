library new_game_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'new_game_state.g.dart';

abstract class NewGameState
    implements Built<NewGameState, NewGameStateBuilder> {
  factory NewGameState([void Function(NewGameStateBuilder b) updates]) =
      _$NewGameState;

  NewGameState._();

  StoreList<GameTemplate> get gameTemplates;
  StoreList<GameLevel> get gameLevels;
  StoreList<Game> get userGames;

  Map<String, String> get currentGameForLevels;

  @nullable
  String get newGameId;

  static NewGameState initial() => NewGameState((b) => b
    ..currentGameForLevels = {}
    ..gameTemplates = StoreList<GameTemplate>()
    ..gameLevels = StoreList<GameLevel>()
    ..userGames = StoreList<Game>()
    ..newGameId = null);
}
