import 'package:flutter/foundation.dart';
import 'package:cash_flow/models/domain/game_event_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_event.g.dart';

abstract class GameEventData {
  Map<String, dynamic> toJson();
}

@JsonSerializable(createFactory: false)
class GameEvent {
  GameEvent({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.type,
    @required this.data,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    final type = GameEventType.fromJson(json['type']);
    final eventData = type.parseGameEventData(json['data']);

    return GameEvent(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: type,
      data: eventData,
    );
  }

  final String id;
  final String name;
  final String description;
  @JsonKey(fromJson: GameEventType.fromJson, toJson: GameEventType.toJson)
  final GameEventType type;
  final GameEventData data;

  Map<String, dynamic> toJson() => _$GameEventToJson(this);
}
