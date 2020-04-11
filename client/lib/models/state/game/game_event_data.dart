library game_event_data;

import 'package:built_value/built_value.dart';

part 'game_event_data.g.dart';

abstract class GameEventData
    implements Built<GameEventData, GameEventDataBuilder> {
  factory GameEventData([void Function(GameEventDataBuilder b) updates]) =
      _$GameEventData;

  GameEventData._();

  int get currentPrice;

  int get maxCount;

  int get nominal;

  int get profitabilityPercent;
}
