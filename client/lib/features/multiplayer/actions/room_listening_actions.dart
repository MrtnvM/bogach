import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/multiplayer/actions/on_current_room_updated_action.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class StartListeningRoomUpdatesAction extends BaseAction {
  StartListeningRoomUpdatesAction(this.roomId) : assert(roomId != null);

  final String roomId;

  @override
  FutureOr<AppState> reduce() {
    final gameService = GetIt.I.get<GameService>();
    final action$ = GetIt.I.get<ReduxActionObserver>().onAction;

    gameService
        .subscribeOnRoomUpdates(roomId)
        .takeUntil(action$
            .whereType<StopListeningRoomUpdatesAction>()
            .where((a) => a.roomId == roomId))
        .map<BaseAction>((room) => OnCurrentRoomUpdatedAction(room))
        .onErrorReturnWith((error) => OnCurrentRoomUpdatedAction(null))
        .listen(dispatch);

    return null;
  }
}

class StopListeningRoomUpdatesAction extends BaseAction {
  StopListeningRoomUpdatesAction(this.roomId) : assert(roomId != null);

  final String roomId;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      s.multiplayer.currentRoom = null;
    });
  }
}
