abstract class PlayerAction {
  const PlayerAction();

  factory PlayerAction.fromJson(Map<String, dynamic> json) {
    throw Exception('Not implemented');
  }

  Map<String, dynamic> toJson();
}
