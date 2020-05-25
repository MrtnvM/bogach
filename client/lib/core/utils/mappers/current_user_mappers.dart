import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

UserProfile mapToCurrentUser(FirebaseUser user) {
  return user == null
      ? null
      : UserProfile((b) => b
        ..userId = user.uid
        ..fullName = user.displayName
        ..avatarUrl = user.photoUrl);
}
