import 'package:cash_flow/models/domain/room/room_participant.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  factory Room({
    @required String id,
    String gameTemplateId,
    String ownerId,
    String gameId,
    List<RoomParticipant> participants,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
