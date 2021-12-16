// ignore_for_file: invalid_annotation_target

import 'package:cash_flow/models/domain/user/last_games/last_games.dart';
import 'package:cash_flow/models/domain/user/played_games/played_games.dart';
import 'package:cash_flow/models/domain/user/purchase_profile.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile implements StoreListItem {
  factory UserProfile({
    required String userId,
    @JsonKey(name: 'userName') required String fullName,
    @JsonKey(ignore: true) String? status,
    String? avatarUrl,
    int? currentQuestIndex,
    @JsonKey(defaultValue: false) bool? boughtQuestsAccess,
    @JsonKey(defaultValue: 0) required int multiplayerGamePlayed,
    PurchaseProfile? purchaseProfile,
    @JsonKey(defaultValue: 1) required int profileVersion,
    PlayedGames? playedGames,
    @JsonKey(fromJson: _lastGamesFromJson) required LastGames lastGames,
    @JsonKey(fromJson: _lastGamesFromJson) required LastGames completedGames,
    @JsonKey(defaultValue: <String>[]) required List<String> friends,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.unknownUser(String userId) => UserProfile(
        userId: userId,
        fullName: Strings.unknownUser,
        completedGames: LastGames.empty,
        lastGames: LastGames.empty,
        friends: <String>[],
        multiplayerGamePlayed: 0,
        profileVersion: 1,
      );

  factory UserProfile.withName({
    required String userId,
    required String fullName,
    required String avatarUrl,
  }) =>
      UserProfile(
        userId: userId,
        fullName: fullName,
        avatarUrl: avatarUrl,
        completedGames: LastGames.empty,
        lastGames: LastGames.empty,
        friends: <String>[],
        multiplayerGamePlayed: 0,
        profileVersion: 1,
      );

  @override
  String get id => userId;

  bool get isAnonymous => fullName.isEmpty;

  bool get isOnline => status == 'online';
}

LastGames _lastGamesFromJson(dynamic json) {
  if (json == null) {
    return LastGames.empty;
  }

  return LastGames.fromJson(json);
}
