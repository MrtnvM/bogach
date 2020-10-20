import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_profile.freezed.dart';
part 'purchase_profile.g.dart';

@freezed
abstract class PurchaseProfile with _$PurchaseProfile {
  factory PurchaseProfile({
    @JsonKey(defaultValue: false) bool isQuestsAvailable,
    @JsonKey(defaultValue: 0) int boughtMultiplayerGamesCount,
  }) = _PurchaseProfile;

  factory PurchaseProfile.fromJson(Map<String, dynamic> json) =>
      _$PurchaseProfileFromJson(json);
}
