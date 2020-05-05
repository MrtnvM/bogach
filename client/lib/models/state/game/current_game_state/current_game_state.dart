import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_game_state.freezed.dart';
part 'current_game_state.g.dart';

@freezed
abstract class CurrentGameState with _$CurrentGameState {
  factory CurrentGameState({
    String gameState,
    int monthNumber,
    Map<String, int> participantProgress,
    Map<int, String> winners,
  }) = _CurrentGameState;

  factory CurrentGameState.fromJson(Map<String, dynamic> json) =>
      _$CurrentGameStateFromJson(json);
}
