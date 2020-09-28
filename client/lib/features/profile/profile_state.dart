import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    UserProfile currentUser,
  }) = _ProfileState;

  static ProfileState initial() => const ProfileState();
}
