library new_game_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/game_template.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'new_game_state.g.dart';

abstract class NewGameState
    implements Built<NewGameState, NewGameStateBuilder> {
  factory NewGameState([void Function(NewGameStateBuilder b) updates]) =
      _$NewGameState;

  NewGameState._();

  RefreshableRequestState get getGameTemplatesRequestState;

  StoreList<GameTemplate> get gameTemplates;

  static NewGameState initial() => NewGameState((b) => b
    ..getGameTemplatesRequestState = RefreshableRequestState.idle
    ..gameTemplates = StoreList<GameTemplate>());
}
