import 'dart:async';
import 'dart:io';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class TrackOnlineStatusAction extends BaseAction {
  @override
  Future<AppState?> reduce() async {
    final changeOnlineStatus = (isOnline) {
      scheduleMicrotask(() {
        dispatch(SetOnlineStatusAction(isOnline: isOnline));
      });
    };

    if (Platform.isIOS) {
      FirebaseDatabase.instance
          .reference()
          .child('.info/connected')
          .onValue
          .map((event) => event.snapshot.value == true)
          .listen(changeOnlineStatus);
    } else {
      final connectivity = Connectivity();
      final currentStatus = await connectivity.checkConnectivity();
      final onConnectivityChanged = connectivity.onConnectivityChanged;

      Rx.concat([Stream.value(currentStatus), onConnectivityChanged])
          .map((result) => result != ConnectivityResult.none)
          .listen(changeOnlineStatus);
    }

    return null;
  }
}

class SetOnlineStatusAction extends BaseAction {
  SetOnlineStatusAction({required this.isOnline});

  final bool isOnline;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      s.config = s.config!.copyWith(isOnline: isOnline);
    });
  }
}
