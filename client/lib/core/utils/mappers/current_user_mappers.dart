import 'package:cash_flow/models/domain/user/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

CurrentUser mapToCurrentUser(FirebaseUser user) {
  return user == null
      ? null
      : CurrentUser((b) => b
        ..userId = user.uid
        ..fullName = user.displayName
        ..avatarUrl = user.photoUrl);
}
