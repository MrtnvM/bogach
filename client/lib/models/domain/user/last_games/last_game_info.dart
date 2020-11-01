import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_game_info.freezed.dart';
part 'last_game_info.g.dart';

@freezed
abstract class LastGameInfo with _$LastGameInfo {
  factory LastGameInfo({
    String gameId,
    String templateId,
    String createdAt,
  }) = _LastGameInfo;

  factory LastGameInfo.fromJson(Map<String, dynamic> json) =>
      _$LastGameInfoFromJson(json);
}
