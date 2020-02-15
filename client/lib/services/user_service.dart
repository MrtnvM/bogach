import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  UserService({
    @required this.tokenStorage,
  });

  final TokenStorage tokenStorage;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Observable<void> login() {
    return Observable.fromFuture(_firebaseAuth.signInAnonymously());
  }

  Observable<void> logout() {
    return Observable.just(_firebaseAuth.signOut());
  }
}
