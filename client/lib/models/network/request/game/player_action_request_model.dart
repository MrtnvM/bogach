import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_action_request_model.g.dart';

@JsonSerializable()
class PlayerActionRequestModel {
  PlayerActionRequestModel({
    required this.gameContext,
    required this.eventId,
    this.playerAction,
  })  : assert(eventId != null && eventId != '');

  factory PlayerActionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerActionRequestModelFromJson(json);

  @JsonKey(name: 'context')
  final GameContext gameContext;
  @JsonKey(name: 'action')
  final PlayerAction? playerAction;
  final String? eventId;

  Map<String, dynamic> toJson() => _$PlayerActionRequestModelToJson(this);
}
