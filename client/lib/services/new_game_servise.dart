import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/utils/mappers/new_game_mapper.dart';
import 'package:flutter/cupertino.dart';

class NewGameService {
  NewGameService({
    @required this.apiClient,
  });

  final CashFlowApiClient apiClient;

  Stream<List<GameTemplate>> getGameTemplates() {
    return apiClient.getGameTemplates().map(mapToGameTemplates);
  }

  Stream<String> createNewGame({
    @required String templateId,
    @required String userId,
  }) {
    return apiClient
        .createNewGame(templateId: templateId, userId: userId)
        .map((response) => response.id);
  }
}
