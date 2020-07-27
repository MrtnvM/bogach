library new_game_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'new_game_state.g.dart';

abstract class NewGameState
    implements Built<NewGameState, NewGameStateBuilder> {
  factory NewGameState([void Function(NewGameStateBuilder b) updates]) =
      _$NewGameState;

  NewGameState._();

  RefreshableRequestState get getGameTemplatesRequestState;
  RefreshableRequestState get getGameLevelsRequestState;
  RefreshableRequestState get getUserGamesRequestState;

  StoreList<GameTemplate> get gameTemplates;
  StoreList<GameLevel> get gameLevels;
  StoreList<Game> get userGames;

  RequestState get createNewGameRequestState;
  RequestState get createNewGameByLevelRequestState;

  @nullable
  String get newGameId;

  static NewGameState initial() => NewGameState((b) => b
    ..getGameTemplatesRequestState = RefreshableRequestState.idle
    ..getGameLevelsRequestState = RefreshableRequestState.idle
    ..getUserGamesRequestState = RefreshableRequestState.idle
    ..gameTemplates = StoreList<GameTemplate>()
    ..gameLevels = StoreList<GameLevel>()
    ..userGames = StoreList<Game>()
    ..createNewGameRequestState = RequestState.idle
    ..createNewGameByLevelRequestState = RequestState.idle
    ..newGameId = null);
}
