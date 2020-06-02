import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'create_room_request_model.g.dart';

@JsonSerializable()
class CreateRoomRequestModel {
  CreateRoomRequestModel({
    @required this.participantIds,
    @required this.currentUserId,
    @required this.gameTemplateId,
  })  : assert(participantIds != null),
        assert(currentUserId != null && currentUserId != ''),
        assert(gameTemplateId != null && gameTemplateId != '');

  factory CreateRoomRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomRequestModelFromJson(json);

  final List<String> participantIds;
  final String gameTemplateId;
  final String currentUserId;

  Map<String, dynamic> toJson() => _$CreateRoomRequestModelToJson(this);
}
