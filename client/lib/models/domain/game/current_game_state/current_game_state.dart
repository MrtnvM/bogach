import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/models/domain/game/current_game_state/winner.dart';
import 'package:cash_flow/utils/core/date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_game_state.freezed.dart';
part 'current_game_state.g.dart';

@freezed
abstract class CurrentGameState with _$CurrentGameState {
  factory CurrentGameState({
    @JsonKey(fromJson: fromISO8601DateJson, toJson: toISO8601DateJson)
        DateTime moveStartDateInUTC,
    GameStatus gameStatus,
    int monthNumber,
    Map<String, ParticipantProgress> participantsProgress,
    List<Winner> winners,
  }) = _CurrentGameState;

  factory CurrentGameState.fromJson(Map<String, dynamic> json) =>
      _$CurrentGameStateFromJson(json);
}

enum GameStatus {
  @JsonValue('players_move')
  playersMove,
  @JsonValue('game_over')
  gameOver,
}
