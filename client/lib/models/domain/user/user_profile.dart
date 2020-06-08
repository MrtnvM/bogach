import 'package:flutter/foundation.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile implements StoreListItem {
  factory UserProfile({
    @required String userId,
    @JsonKey(name: 'userName') String fullName,
    String avatarUrl,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  @override
  @late
  Object get id => userId;

  @late
  bool get isAnonymous => fullName == null || fullName.isEmpty;
}
