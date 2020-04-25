import 'package:flutter/foundation.dart';

class GameContext {
  const GameContext({
    @required this.gameId,
    @required this.userId,
  })  : assert(gameId != null && gameId != ''),
        assert(userId != null && userId != '');

  final String userId;
  final String gameId;

  Map<String, dynamic> toMap() => {'gameId': gameId, 'userId': userId};
}
