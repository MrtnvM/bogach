library current_user;

import 'package:built_value/built_value.dart';

part 'current_user.g.dart';

abstract class CurrentUser implements Built<CurrentUser, CurrentUserBuilder> {
  factory CurrentUser([void Function(CurrentUserBuilder b) updates]) =
      _$CurrentUser;

  CurrentUser._();

  String get fullName;

  @nullable
  String get avatarUrl;
}
