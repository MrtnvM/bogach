class GameContext {
  const GameContext(this.gameId, this.userId)
      : assert(gameId != null && gameId != ''),
        assert(userId != null && userId != '');

  final String userId;
  final String gameId;

  Map<String, dynamic> toMap() => {'gameId': gameId, 'userId': userId};
}
