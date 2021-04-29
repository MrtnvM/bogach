import 'package:cash_flow/app/app_state.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;

Store<AppState> useStore() {
  final context = useContext();
  final store = StoreProvider.of<AppState>(context, 'Store Hook');
  return store as Store<AppState>;
}
