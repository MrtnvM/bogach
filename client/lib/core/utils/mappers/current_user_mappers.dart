import 'package:cash_flow/models/state/user/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

CurrentUser mapToCurrentUser(AuthResult event) {
  return CurrentUser((b) => b..fullName = event.user.displayName);
}

CurrentUser mapUserToCurrentUser(FirebaseUser user) {
  return user == null
      ? null
      : CurrentUser((b) => b..fullName = user.displayName);
}
