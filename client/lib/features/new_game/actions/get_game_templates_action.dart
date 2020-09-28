import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:get_it/get_it.dart';

class GetGameTemplatesAction extends BaseAction {
  GetGameTemplatesAction({bool isRefreshing = false})
      : super(isRefreshing: isRefreshing);

  @override
  NetworkRequest get operationKey => NetworkRequest.loadGameTemplates;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final gameTemplates = await gameService.getGameTemplates();

    return state.rebuild((s) {
      s.newGame.gameTemplates = StoreList<GameTemplate>(gameTemplates);
    });
  }
}
