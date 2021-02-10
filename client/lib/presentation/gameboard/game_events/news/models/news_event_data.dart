import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_event_data.freezed.dart';

part 'news_event_data.g.dart';

@freezed
abstract class NewsEventData
    with _$NewsEventData
    implements GameEventData {
  factory NewsEventData({
    @required String imageUrl,
  }) = _NewsEventData;

  factory NewsEventData.fromJson(Map<String, dynamic> json) =>
      _$NewsEventDataFromJson(json);
}
