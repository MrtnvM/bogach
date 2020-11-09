import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/game/actions/on_game_error.dart';
import 'package:cash_flow/features/game/actions/on_game_state_changed_action.dart';
import 'package:cash_flow/features/game/actions/set_game_context.dart';
import 'package:cash_flow/features/game/actions/set_game_participants_profiles_action.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class StartGameAction extends BaseAction {
  StartGameAction(this.gameContext) : assert(gameContext != null);

  final GameContext gameContext;

  @override
  FutureOr<void> before() async {
    super.before();
    await dispatchFuture(SetGameContextAction(gameContext));
  }

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final userService = GetIt.I.get<UserService>();
    final action$ = GetIt.I.get<ReduxActionObserver>().onAction;

    final onStopActiveGame = action$.whereType<StopActiveGameAction>();

    final userProfiles = gameService
        .getGame(gameContext)
        .take(1)
        .asyncMap((game) => userService.loadProfiles(game.participantsIds))
        .map<BaseAction>(
          (profiles) => SetGameParticipantsProfilesAction(profiles),
        )
        .onErrorReturnWith((e) => OnGameErrorAction(e));

    final gameSubscription = gameService
        .getGame(gameContext)
        .map<BaseAction>((game) {
          return OnGameStateChangedAction(game);
        })
        .onErrorReturnWith((e) => OnGameErrorAction(e))
        .takeUntil(onStopActiveGame);

    Rx.concat([userProfiles, gameSubscription])
        .takeUntil(onStopActiveGame)
        .listen(dispatch);

    return state.rebuild((s) {
      return s.game.activeGameState = ActiveGameState.waitingForStart();
    });
  }

  @override
  String toString() {
    return '${super.toString()} $gameContext';
  }
}

class StopActiveGameAction extends BaseAction {
  @override
  AppState reduce() {
    return state.rebuild((s) {
      s.game.currentGame = null;
    });
  }
}
