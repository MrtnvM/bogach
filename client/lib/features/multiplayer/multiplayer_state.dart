import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/core/search_query_result.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'multiplayer_state.g.dart';

abstract class MultiplayerState
    implements Built<MultiplayerState, MultiplayerStateBuilder> {
  factory MultiplayerState([void Function(MultiplayerStateBuilder) updates]) =
      _$MultiplayerState;
  MultiplayerState._();

  StoreList<UserProfile> get userProfiles;
  SearchQueryResult get userProfilesQuery;
  RequestState get userProfilesQueryRequestState;

  @nullable
  GameTemplate get selectedGameTemplate;

  @nullable
  Room get currentRoom;

  RequestState get createRoomRequestState;
  RequestState get createRoomGameRequestState;
  RequestState get joinRoomRequestState;

  static MultiplayerState initial() => MultiplayerState((b) => b
    ..userProfiles = StoreList<UserProfile>()
    ..userProfilesQuery = const SearchQueryResult()
    ..userProfilesQueryRequestState = RequestState.idle
    ..createRoomRequestState = RequestState.idle
    ..createRoomGameRequestState = RequestState.idle
    ..joinRoomRequestState = RequestState.idle);
}
