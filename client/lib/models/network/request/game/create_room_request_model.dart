import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'create_room_request_model.g.dart';

@JsonSerializable()
class CreateRoomRequestModel {
  CreateRoomRequestModel({
    @required this.currentUserId,
    @required this.gameTemplateId,
    @required this.invitedUsers,
  })  : assert(currentUserId != null && currentUserId != ''),
        assert(gameTemplateId != null && gameTemplateId != ''),
        assert(invitedUsers != null);

  factory CreateRoomRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomRequestModelFromJson(json);

  final String gameTemplateId;
  final String currentUserId;
  final List<String> invitedUsers;

  Map<String, dynamic> toJson() => _$CreateRoomRequestModelToJson(this);
}
