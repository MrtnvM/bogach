abstract class PlayerAction {
  const PlayerAction();

  // ignore: avoid_unused_constructor_parameters
  factory PlayerAction.fromJson(Map<String, dynamic>? json) {
    throw Exception('Not implemented: $json');
  }

  Map<String, dynamic> toJson();
}
