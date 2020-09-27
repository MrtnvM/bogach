import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/core/search_query_result.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'multiplayer_state.g.dart';

abstract class MultiplayerState
    implements Built<MultiplayerState, MultiplayerStateBuilder> {
  factory MultiplayerState([void Function(MultiplayerStateBuilder) updates]) =
      _$MultiplayerState;
  MultiplayerState._();

  StoreList<UserProfile> get userProfiles;
  SearchQueryResult get userProfilesQuery;

  @nullable
  GameTemplate get selectedGameTemplate;

  @nullable
  Room get currentRoom;

  static MultiplayerState initial() => MultiplayerState((b) => b
    ..userProfiles = StoreList<UserProfile>()
    ..userProfilesQuery = const SearchQueryResult());
}
