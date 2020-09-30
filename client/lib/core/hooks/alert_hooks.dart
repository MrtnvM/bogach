import 'package:cash_flow/utils/dialogs.dart';
import 'package:flutter/material.dart';

typedef RetriableShowAlertFunction = void Function(
  dynamic error,
  VoidCallback retry,
);

RetriableShowAlertFunction showWarningAlert({
  @required BuildContext context,
  String Function(dynamic) message,
  String submitButtonText,
  bool needCancelButton,
}) {
  return (error, retry) {
    final errorMessage = message?.call(error) ?? error?.toString();

    showWarningAlertDialog(
      context: context,
      errorMessage: errorMessage,
      needCancelButton: needCancelButton,
      onSubmit: retry,
    );
  };
}
