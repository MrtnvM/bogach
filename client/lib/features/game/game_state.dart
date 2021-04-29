library game_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'game_state.g.dart';

abstract class GameState implements Built<GameState, GameStateBuilder> {
  factory GameState([void Function(GameStateBuilder b)? updates]) = _$GameState;

  GameState._();

  Map<String, Game> get games;
  Map<String, ActiveGameState> get activeGameStates;

  StoreList<UserProfile> get participantProfiles;

  Map<int, Ad> get monthResultAds;

  static GameState initial() => GameState(
        (b) => b
          ..activeGameStates = <String, ActiveGameState>{}
          ..games = <String, Game>{}
          ..participantProfiles = StoreList<UserProfile>()
          ..monthResultAds = <int, Ad>{},
      );
}
