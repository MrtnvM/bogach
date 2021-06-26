import 'package:cash_flow/utils/core/date.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'online_profile.freezed.dart';

part 'online_profile.g.dart';

@freezed
class OnlineProfile with _$OnlineProfile {
  factory OnlineProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
    @JsonKey(fromJson: fromISO8601DateJson, includeIfNull: false)
        DateTime? onlineAt,
  }) = _OnlineProfile;

  factory OnlineProfile.fromJson(Map<String, dynamic> json) =>
      _$OnlineProfileFromJson(json);
}
