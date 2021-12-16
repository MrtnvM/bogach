import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:fimber/fimber.dart';
import 'package:get_it/get_it.dart';

class OnCurrentRoomUpdatedAction extends BaseAction {
  OnCurrentRoomUpdatedAction(this.room);

  final Room? room;

  @override
  Future<AppState> reduce() async {
    return state.rebuild((s) {
      s.multiplayer.rooms![room!.id] = room;
    });
  }

  @override
  void after() {
    super.after();

    if (room != null) {
      _loadProfiles();
    }
  }

  void _loadProfiles() {
    final userService = GetIt.I.get<UserService>();

    final isParticipantProfileLoaded = (id) {
      return store.state.multiplayer.userProfiles.itemsMap[id] != null;
    };

    final participantWithoutProfile = room!.participants
        .where((p) => !isParticipantProfileLoaded(p.id))
        .map((p) => p.id)
        .toList();

    userService
        .loadProfiles(participantWithoutProfile)
        .catchError((error) {
          Fimber.e('PARTICIPANT PROFILES LOADING FAILED\n$error', ex: error);
          return const <UserProfile>[];
        })
        .then((profiles) => _OnProfilesLoadedAction(profiles))
        .then(dispatch);
  }
}

class _OnProfilesLoadedAction extends BaseAction {
  _OnProfilesLoadedAction(this.userProfiles);

  final List<UserProfile> userProfiles;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      s.multiplayer.userProfiles!.addAll(userProfiles);
    });
  }
}
