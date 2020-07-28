import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game_config/game_config.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/possession_state.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
abstract class Game with _$Game implements StoreListItem {
  factory Game({
    @required String id,
    @required String name,
    @required String type,
    @required CurrentGameState state,
    @required List<String> participants,
    @required Map<String, PossessionState> possessionState,
    @required Map<String, Account> accounts,
    @required Target target,
    @required List<GameEvent> currentEvents,
    @required GameConfig config,
    @JsonKey(fromJson: _timestampToDate) DateTime createdAt,
    @JsonKey(fromJson: _timestampToDate) DateTime updatedAt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

DateTime _timestampToDate(dynamic timestamp) {
  final Timestamp timestampValue = timestamp;

  return DateTime.fromMicrosecondsSinceEpoch(
    timestampValue.microsecondsSinceEpoch,
  );
}
