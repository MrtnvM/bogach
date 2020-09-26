import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/network/network_actions.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

abstract class BaseAction extends Action<AppState> {
  Future<T> performRequest<T>(
    Future<T> request,
    NetworkRequest requestName, {
    bool isRefreshing = false,
  }) {
    dispatch(SetRequestStateAction(
      requestName,
      isRefreshing ? RequestState.refreshing : RequestState.inProgress,
    ));

    return request.then(
      (value) {
        dispatch(SetRequestStateAction(requestName, RequestState.success));
        return value;
      },
    ).catchError(
      (error) {
        dispatch(SetRequestStateAction(requestName, RequestState.error));

        throw error;
      },
    );
  }
}
