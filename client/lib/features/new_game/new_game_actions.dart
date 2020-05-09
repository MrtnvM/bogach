import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class GetGameTemplatesAsyncAction extends AsyncAction<List<GameTemplate>> {}

class CreateNewGameAsyncAction extends AsyncAction<String> {
  CreateNewGameAsyncAction({@required this.templateId});

  final String templateId;
}
