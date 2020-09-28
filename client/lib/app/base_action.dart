import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/network/network_actions.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:dash_kit_core/dash_kit_core.dart' hide Reducer;
import 'package:async_redux/async_redux.dart';

abstract class BaseAction extends Action<AppState> {
  BaseAction({this.isRefreshing = false});

  final bool isRefreshing;

  NetworkRequest get operationKey => null;

  @override
  Reducer<AppState> wrapReduce(Reducer<AppState> reduce) {
    if (operationKey == null) {
      return reduce;
    }

    dispatch(SetRequestStateAction(
      operationKey,
      isRefreshing == true ? RequestState.refreshing : RequestState.inProgress,
    ));

    return () async {
      try {
        final newState = await reduce();
        dispatch(SetRequestStateAction(operationKey, RequestState.success));
        return newState;

        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        dispatch(SetRequestStateAction(operationKey, RequestState.error));
        rethrow;
      }
    };
  }
}
