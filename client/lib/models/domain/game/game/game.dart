import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/type/game_type.dart';
import 'package:cash_flow/models/domain/game/game_config/game_config.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/participant/participant.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/utils/core/date.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
abstract class Game with _$Game implements StoreListItem {
  factory Game({
    @required String id,
    @required String name,
    @JsonKey(fromJson: GameType.fromJson, toJson: GameType.toJson)
    @required
        GameType type,
    @required CurrentGameState state,
    @required List<String> participantsIds,
    @required Map<String, Participant> participants,
    @required Target target,
    @required List<GameEvent> currentEvents,
    @required GameConfig config,
    @JsonKey(fromJson: fromISO8601DateJson) DateTime createdAt,
    @JsonKey(fromJson: fromISO8601DateJson) DateTime updatedAt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
