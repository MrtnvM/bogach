import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_game_state.freezed.dart';
part 'current_game_state.g.dart';

@freezed
abstract class CurrentGameState with _$CurrentGameState {
  factory CurrentGameState({
    @JsonKey(name: 'gameState') GameStatus gameStatus,
    int monthNumber,
    Map<String, int> participantProgress,
    Map<int, String> winners,
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
