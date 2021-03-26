import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

UserProfile mapToUserProfile(User user) {
  return user == null
      ? null
      : UserProfile(
          userId: user.uid,
          fullName: user.displayName,
          avatarUrl: user.photoURL,
        );
}
