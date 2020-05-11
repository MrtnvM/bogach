class GameError {
  const GameError(this.error, this.gameId);

  final dynamic error;
  final String gameId;

  @override
  String toString() {
    return 'GAME ERROR: game_id = $gameId' '\nERROR: $error';
  }
}
