library login_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

part 'profile_state.g.dart';

abstract class ProfileState
    implements Built<ProfileState, ProfileStateBuilder> {
  factory ProfileState([void Function(ProfileStateBuilder b) updates]) =
      _$ProfileState;

  ProfileState._();

  @nullable
  UserProfile get currentUser;

  static ProfileState initial() => ProfileState((b) => b..currentUser = null);
}
