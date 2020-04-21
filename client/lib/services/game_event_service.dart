import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/domain/player_action.dart';
import 'package:flutter/foundation.dart';

class GameEventService {
  GameEventService({@required this.apiClient});

  final CashFlowApiClient apiClient;

  Stream<void> sendPlayerAction({
    @required GameContext context,
    @required String eventId,
    @required PlayerAction action,
  }) {
    return apiClient.sendPlayerAction(context, action, eventId);
  }
}
