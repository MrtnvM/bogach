import 'package:built_value/built_value.dart';
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

  static MultiplayerState initial() => MultiplayerState((b) => b
    ..userProfiles = StoreList<UserProfile>()
    ..userProfilesQuery = const SearchQueryResult()
    ..userProfilesQueryRequestState = RequestState.idle);
}
