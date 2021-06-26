import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/online/online_profile.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'multiplayer_state.g.dart';

abstract class MultiplayerState
    implements Built<MultiplayerState, MultiplayerStateBuilder> {
  factory MultiplayerState([void Function(MultiplayerStateBuilder)? updates]) =
      _$MultiplayerState;
  MultiplayerState._();

  GameTemplate? get selectedGameTemplate;

  String? get createdRoomId;

  Map<String, Room?> get rooms;

  List<OnlineProfile> get onlineProfiles;
  StoreList<UserProfile> get userProfiles;

  static MultiplayerState initial() => MultiplayerState(
        (b) => b
          ..userProfiles = StoreList<UserProfile>()
          ..rooms = <String, Room>{}
          ..onlineProfiles = [],
      );
}
