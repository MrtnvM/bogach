import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

OperationState? useOperationState(Operation operation) {
  final operationState = useGlobalState((s) => s.getOperationState(operation));
  return operationState;
}
