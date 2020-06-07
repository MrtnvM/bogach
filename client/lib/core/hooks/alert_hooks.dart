import 'package:cash_flow/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef RetriableShowAlertFunction = void Function(
  dynamic error,
  VoidCallback retry,
);

RetriableShowAlertFunction useWarningAlert({
  String Function(dynamic) message,
  String submitButtonText,
  bool needCancelButton,
}) {
  final context = useContext();

  return (error, retry) {
    final errorMessage = message?.call(error) ?? error?.toString();

    showWarningAlertDialog(
      context: context,
      errorMessage: errorMessage,
      needCancelButton: false,
      onSubmit: retry,
    );
  };
}
