// ignore_for_file: invalid_annotation_target

import 'package:cash_flow/utils/core/date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_game_info.freezed.dart';
part 'last_game_info.g.dart';

@freezed
class LastGameInfo with _$LastGameInfo {
  factory LastGameInfo({
    required String gameId,
    required String templateId,
    @JsonKey(fromJson: fromISO8601DateJson) required DateTime? createdAt,
  }) = _LastGameInfo;

  factory LastGameInfo.fromJson(Map<String, dynamic> json) =>
      _$LastGameInfoFromJson(json);
}
