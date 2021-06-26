import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/participant/participant_progress.dart';
import 'package:cash_flow/models/domain/game/possession_state/possession_state.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed
class Participant with _$Participant {
  factory Participant({
    required String id,
    required PossessionState possessionState,
    required Account account,
    required ParticipantProgress progress,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}
