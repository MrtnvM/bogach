import 'package:dash_kit_core/dash_kit_core.dart' hide StoreProvider;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:async_redux/async_redux.dart';

Future<void> Function(Action) useDispatcher() {
  final context = useContext();
  final storeProvider = StoreProvider.of(context, 'dispatcher');
  return storeProvider.dispatchFuture;
}
