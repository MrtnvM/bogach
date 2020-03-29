import 'package:cash_flow/models/state/posessions_state/user_possession_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class ListenPossessionsStartAction extends Action {
  ListenPossessionsStartAction(this.gameId);

  final String gameId;
}

class ListenPossessionsSuccessAction extends Action {
  ListenPossessionsSuccessAction(this.state);

  final UserPossessionState state;
}

class ListenPossessionsErrorAction extends Action {
  ListenPossessionsErrorAction();
}

class StopListenPossessionsStartAction extends Action {
  StopListenPossessionsStartAction();
}
