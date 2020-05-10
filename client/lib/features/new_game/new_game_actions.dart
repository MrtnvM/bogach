import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class GetGameTemplatesAsyncAction extends AsyncAction<List<GameTemplate>> {
  GetGameTemplatesAsyncAction({this.isRefreshing = false})
      : assert(isRefreshing != null);

  final bool isRefreshing;
}

class CreateNewGameAsyncAction extends AsyncAction<String> {
  CreateNewGameAsyncAction({@required this.templateId})
      : assert(templateId != null);

  final String templateId;
}

class GetUserGamesAsyncAction extends AsyncAction<List<Game>> {
  GetUserGamesAsyncAction({
    @required this.userId,
    this.isRefreshing = false,
  })  : assert(userId != null),
        assert(isRefreshing != null);

  final String userId;
  final bool isRefreshing;
}
