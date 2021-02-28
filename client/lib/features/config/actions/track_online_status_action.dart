import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class TrackOnlineStatusAction extends BaseAction {
  @override
  FutureOr<AppState> reduce() {
    FirebaseDatabase.instance
        .reference()
        .child('.info/connected')
        .onValue
        .map((event) => event?.snapshot?.value == true)
        .listen((isOnline) {
      dispatch(SetOnlineStatusAction(isOnline: isOnline));
    });

    return null;
  }
}

class SetOnlineStatusAction extends BaseAction {
  SetOnlineStatusAction({@required this.isOnline});

  final bool isOnline;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      s.config = s.config.copyWith(isOnline: isOnline);
    });
  }
}
