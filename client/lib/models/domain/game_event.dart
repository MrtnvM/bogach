import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cash_flow/models/domain/game_event_type.dart';

abstract class GameEventData {}

class GameEvent {
  GameEvent({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.type,
    @required this.data,
  });

  final String id;
  final String name;
  final String description;
  final GameEventType type;
  final GameEventData data;
}
