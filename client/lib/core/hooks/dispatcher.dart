import 'package:async_redux/async_redux.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<void> Function(BaseAction) useDispatcher() {
  final context = useContext();
  final storeProvider = StoreProvider.of<AppState>(context, 'dispatcher');
  return storeProvider.dispatchFuture;
}
