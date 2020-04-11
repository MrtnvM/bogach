import 'package:cash_flow/models/domain/game_data.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class ListenGameStateStartAction extends Action {
  ListenGameStateStartAction(this.gameId);

  final String gameId;
}

class ListenGameStateSuccessAction extends Action {
  ListenGameStateSuccessAction(this.data);

  final GameData data;
}

class ListenGameStateErrorAction extends Action {
  ListenGameStateErrorAction();
}

class StopListenGameStateAction extends Action {
  StopListenGameStateAction();
}
