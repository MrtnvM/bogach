import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_progress.freezed.dart';
part 'participant_progress.g.dart';

@freezed
abstract class ParticipantProgress with _$ParticipantProgress {
  factory ParticipantProgress({
    @required ParticipantProgressStatus status,
    @required int currentEventIndex,
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
