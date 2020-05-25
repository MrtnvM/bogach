library current_user;

import 'package:built_value/built_value.dart';

part 'user_profile.g.dart';

abstract class UserProfile implements Built<UserProfile, UserProfileBuilder> {
  factory UserProfile([void Function(UserProfileBuilder b) updates]) =
      _$UserProfile;

  UserProfile._();

  String get userId;

  @nullable
  String get fullName;

  @nullable
  String get avatarUrl;
}
