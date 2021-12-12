import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/multiplayer/actions/on_current_room_updated_action.dart';
import 'package:cash_flow/features/profile/actions/logout_action.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class StartListeningRoomUpdatesAction extends BaseAction {
  StartListeningRoomUpdatesAction(this.roomId);

  final String roomId;

  @override
  AppState? reduce() {
    final gameService = GetIt.I.get<GameService>();
    final action$ = GetIt.I.get<ReduxActionObserver>().onAction;

    gameService
        .subscribeOnRoomUpdates(roomId)
        .takeUntil(Rx.merge([
          action$
              .whereType<StopListeningRoomUpdatesAction>()
              .where((a) => a.roomId == roomId),
          action$.whereType<LogoutAction>(),
        ]))
        .map<BaseAction>((room) => OnCurrentRoomUpdatedAction(room))
        .onErrorReturnWith((error, st) => OnCurrentRoomUpdatedAction(null))
        .listen(dispatch);

    return null;
  }
}

class StopListeningRoomUpdatesAction extends BaseAction {
  StopListeningRoomUpdatesAction(this.roomId);

  final String roomId;

  @override
  AppState? reduce() {
    return null;
  }
}
