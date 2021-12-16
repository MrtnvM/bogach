// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_profile.freezed.dart';
part 'purchase_profile.g.dart';

@freezed
class PurchaseProfile with _$PurchaseProfile {
  factory PurchaseProfile({
    @JsonKey(defaultValue: false) required bool isQuestsAvailable,
    @JsonKey(defaultValue: 0) required int boughtMultiplayerGamesCount,
  }) = _PurchaseProfile;

  factory PurchaseProfile.fromJson(Map<String, dynamic> json) =>
      _$PurchaseProfileFromJson(json);
}
