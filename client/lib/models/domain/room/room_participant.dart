import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_participant.freezed.dart';
part 'room_participant.g.dart';

@freezed
abstract class RoomParticipant with _$RoomParticipant {
  factory RoomParticipant({
    String id,
    RoomParticipantStatus status,
  }) = _RoomParticipant;

  factory RoomParticipant.fromJson(Map<String, dynamic> json) =>
      _$RoomParticipantFromJson(json);
}

enum RoomParticipantStatus {
  waiting,
  ready,
}
