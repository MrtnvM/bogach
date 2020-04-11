library game_event;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/network/responses/game/game_event_type.dart';
import 'package:cash_flow/models/state/game/game_event_data.dart';

part 'game_event.g.dart';

abstract class GameEvent implements Built<GameEvent, GameEventBuilder> {
  factory GameEvent([void Function(GameEventBuilder b) updates]) = _$GameEvent;

  GameEvent._();

  String get id;

  String get name;

  String get description;

  GameEventType get type;

  GameEventData get data;
}
