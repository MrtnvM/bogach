import 'package:cash_flow/models/state/game/account/account.dart';
import 'package:cash_flow/models/state/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/state/game/game_event/game_event.dart';
import 'package:cash_flow/models/state/game/possession_state/possession_state.dart';
import 'package:cash_flow/models/state/game/target/target.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
abstract class Game with _$Game {
  factory Game({
    @required String id,
    @required String name,
    @required String type,
    @required CurrentGameState state,
    @required List<String> participants,
    @required Map<String, PossessionState> possessionState,
    @required Map<String, Account> accounts,
    @required Target target,
    @required List<GameEvent> currentEvents,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
