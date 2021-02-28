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
abstract class UserProfile with _$UserProfile implements StoreListItem {
  factory UserProfile({
    @required String userId,
    @JsonKey(name: 'userName') String fullName,
    @JsonKey(ignore: true) String status,
    String avatarUrl,
    int currentQuestIndex,
    @JsonKey(defaultValue: false) bool boughtQuestsAccess,
    @JsonKey(defaultValue: 0) int multiplayerGamePlayed,
    PurchaseProfile purchaseProfile,
    @JsonKey(defaultValue: 1) int profileVersion,
    PlayedGames playedGames,
    @JsonKey(fromJson: _lastGamesFromJson) LastGames lastGames,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.unknownUser(String userId) => UserProfile(
        userId: userId,
        fullName: Strings.unknownUser,
      );

  @override
  @late
  Object get id => userId;

  @late
  bool get isAnonymous => fullName == null || fullName.isEmpty;
}

LastGames _lastGamesFromJson(dynamic json) {
  if (json == null) {
    return LastGames.empty;
  }

  return LastGames.fromJson(json);
}
