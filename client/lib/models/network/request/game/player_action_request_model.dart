import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/domain/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonSerializable()
class PlayerActionRequestModel {
  PlayerActionRequestModel({
    @required this.gameContext,
    @required this.playerAction,
    @required this.eventId,
  })  : assert(gameContext != null),
        assert(playerAction != null),
        assert(eventId != null && eventId != '');

  final GameContext gameContext;
  final PlayerAction playerAction;
  final String eventId;

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'context': gameContext.toMap(),
      'action': playerAction.toMap(),
    };
  }
}
