import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_context.g.dart';

@JsonSerializable()
class GameContext {
  const GameContext({
    required this.gameId,
    required this.userId,
  });

  factory GameContext.fromJson(Map<String, dynamic> json) =>
      _$GameContextFromJson(json);

  final String userId;
  final String gameId;

  Map<String, dynamic> toJson() => _$GameContextToJson(this);

  @override
  String toString() {
    return 'GameContext: game_id = $gameId, user_id = $userId';
  }
}
