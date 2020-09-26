library network_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'network_state.g.dart';

abstract class NetworkState
    implements Built<NetworkState, NetworkStateBuilder> {
  factory NetworkState([void Function(NetworkStateBuilder b) updates]) =
      _$NetworkState;

  NetworkState._();

  Map<NetworkRequest, RequestState> get requestStates;

  static NetworkState initial() => NetworkState((b) => b..requestStates = {});

  RequestState getRequestState(NetworkRequest request) {
    return requestStates[request] ?? RequestState.idle;
  }
}
