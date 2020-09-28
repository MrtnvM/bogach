import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class SetRequestStateAction extends BaseAction {
  SetRequestStateAction(this.request, this.requestState);

  final NetworkRequest request;
  final RequestState requestState;

  @override
  FutureOr<AppState> reduce() {
    if (request == null || requestState == null) {
      return state;
    }

    return state.rebuild(
      (s) => s.network.requestStates[request] = requestState,
    );
  }

  @override
  String toString() {
    return '${super.toString()} ($request = $requestState)';
  }
}
