import 'package:cash_flow/models/state/user/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

CurrentUser mapToCurrentUser(FirebaseUser user) {
  return user == null
      ? null
      : CurrentUser((b) => b
        ..fullName = user.displayName
        ..avatarUrl = user.photoUrl);
}
