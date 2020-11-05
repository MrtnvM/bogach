import 'package:cash_flow/models/domain/game/current_game_state/month_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_progress.freezed.dart';
part 'participant_progress.g.dart';

@freezed
abstract class ParticipantProgress with _$ParticipantProgress {
  factory ParticipantProgress({
    @required ParticipantProgressStatus status,
    @required int currentEventIndex,
    @required int currentMonthForParticipant,
    @required List<MonthResult> monthResults,
    @required double progress,
  }) = _ParticipantProgress;

  factory ParticipantProgress.fromJson(Map<String, dynamic> json) =>
      _$ParticipantProgressFromJson(json);
}

enum ParticipantProgressStatus {
  @JsonValue('player_move')
  playerMove,
  @JsonValue('month_result')
  monthResult,
}
