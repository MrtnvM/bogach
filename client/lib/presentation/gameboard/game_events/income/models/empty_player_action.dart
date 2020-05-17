import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'empty_player_action.g.dart';

@JsonSerializable()
class EmptyPlayerAction extends PlayerAction {
  const EmptyPlayerAction();

  @override
  Map<String, dynamic> toJson() => _$EmptyPlayerActionToJson(this);
}
