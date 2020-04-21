import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/domain/player_action.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:cash_flow/api_client/response_mappers.dart' as rm;

class CashFlowApiClient extends ApiClient {
  CashFlowApiClient({
    @required ApiEnvironment environment,
    @required Dio dio,
  }) : super(environment: environment, dio: dio, delegate: null);

  Stream<void> sendPlayerAction(
    GameContext context,
    PlayerAction action,
    String eventId,
  ) =>
      post(
        path: 'handleGameEvent',
        body: {
          'eventId': eventId,
          'context': context.toMap(),
          'action': action.toMap(),
        },
        responseMapper: rm.voidResponse,
      );
}
