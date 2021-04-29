
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_type.freezed.dart';

const _singleplayer = 'singleplayer';
const _multiplayer = 'multiplayer';

@freezed
class GameType with _$GameType {
  const GameType._();

  factory GameType.singleplayer() = SingleplayerGameType;
  factory GameType.multiplayer() = MultiplayerGameType;

  String jsonValue() => map(
        singleplayer: (_) => _singleplayer,
        multiplayer: (_) => _multiplayer,
      );

  static GameType fromJson(String? json) {
    switch (json) {
      case _singleplayer:
        return GameType.singleplayer();

      case _multiplayer:
        return GameType.multiplayer();

      default:
        throw Exception('Unknown GameType value');
    }
  }

  static String toJson(GameType type) {
    return type.jsonValue();
  }

}
