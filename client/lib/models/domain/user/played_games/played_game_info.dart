// ignore_for_file: invalid_annotation_target

import 'package:cash_flow/utils/core/date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'played_game_info.freezed.dart';
part 'played_game_info.g.dart';

@freezed
class PlayedGameInfo with _$PlayedGameInfo {
  factory PlayedGameInfo({
    required String gameId,
    @JsonKey(fromJson: fromISO8601DateJson) required DateTime? createdAt,
  }) = _PlayedGameInfo;

  factory PlayedGameInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayedGameInfoFromJson(json);
}
