import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:cash_flow/api_client/response_mappers.dart' as rm;

class CashFlowApiClient extends ApiClient {
  CashFlowApiClient({
    @required ApiEnvironment environment,
    @required Dio dio,
  }) : super(environment: environment, dio: dio, delegate: null);

  Stream<void> sendPlayerAction(PlayerActionRequestModel playerAction) => post(
        path: 'handleGameEvent',
        body: playerAction.toJson(),
        responseMapper: rm.voidResponse,
      );
}
