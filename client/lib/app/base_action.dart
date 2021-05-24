import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

abstract class BaseAction extends Action<AppState> {
  BaseAction({bool isRefreshing = false}) : super(isRefreshing: isRefreshing);

  @override
  Operation? get operationKey => null;
}
