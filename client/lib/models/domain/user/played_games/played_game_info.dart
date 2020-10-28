import 'package:freezed_annotation/freezed_annotation.dart';

part 'played_game_info.freezed.dart';
part 'played_game_info.g.dart';

@freezed
abstract class PlayedGameInfo with _$PlayedGameInfo {
    factory PlayedGameInfo({
    String gameId,
    DateTime createdAt,
  }) = _PlayedGameInfo;

  factory PlayedGameInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayedGameInfoFromJson(json);
}