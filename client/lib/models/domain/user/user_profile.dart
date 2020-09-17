import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile implements StoreListItem {
  factory UserProfile({
    @required String userId,
    @JsonKey(name: 'userName') String fullName,
    String avatarUrl,
    int currentQuestIndex,
    @JsonKey(defaultValue: false) bool boughtQuestsAccess,
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
