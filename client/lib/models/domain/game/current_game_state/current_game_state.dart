import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'current_game_state.freezed.dart';
part 'current_game_state.g.dart';

@freezed
abstract class CurrentGameState with _$CurrentGameState {
  factory CurrentGameState({
    @JsonKey(fromJson: _fromJson, toJson: _toJson) DateTime moveStartDateInUTC,
    GameStatus gameStatus,
    int monthNumber,
    Map<String, ParticipantProgress> participantsProgress,
    Map<int, String> winners,
  }) = _CurrentGameState;

  factory CurrentGameState.fromJson(Map<String, dynamic> json) =>
      _$CurrentGameStateFromJson(json);
}

final _dateFormatter = DateFormat('yyyy-MM-DDTHH:mm:ss.sssZ');
DateTime _fromJson(String date) => DateTime.parse(date);
String _toJson(DateTime date) => _dateFormatter.format(date);

enum GameStatus {
  @JsonValue('players_move')
  playersMove,
  @JsonValue('game_over')
  gameOver,
}
