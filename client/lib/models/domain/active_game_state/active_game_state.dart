import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_game_state.freezed.dart';

@freezed
abstract class ActiveGameState with _$ActiveGameState {
  ActiveGameState._();

  factory ActiveGameState.waitingForStart() = ActiveGameWaitingForStartState;

  factory ActiveGameState.gameEvent({
    @required int eventIndex,
    @required bool isSent,
  }) = ActiveGameGameEventState;

  factory ActiveGameState.waitingPlayers(
    List<String> playersIds,
  ) = ActiveGameWaitingPlayersState;

  factory ActiveGameState.monthResult() = ActiveGameMonthResultState;

  factory ActiveGameState.gameOver({
    @required Map<int, String> winners,
    @required int monthNumber,
  }) = ActiveGameGameOverState;
}
