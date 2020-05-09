abstract class PlayerAction {
  const PlayerAction();

  factory PlayerAction.fromJson(Map<String, dynamic> json) {
    throw Exception('Not implemented: $json');
  }

  Map<String, dynamic> toJson();
}
