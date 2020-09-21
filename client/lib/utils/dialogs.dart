import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';

void showWarningAlertDialog({
  BuildContext context,
  String errorMessage,
  String submitButtonText,
  VoidCallback onSubmit,
  bool needCancelButton,
}) {
  showAlert(
    title: Strings.commonError,
    context: context,
    message: errorMessage,
    submitButtonText: submitButtonText,
    onSubmit: onSubmit,
    needCancelButton: needCancelButton,
  );
}

Future<dynamic> showAlert({
  @required BuildContext context,
  String title,
  String message,
  VoidCallback onSubmit,
  String cancelButtonText,
  String submitButtonText,
  bool needCancelButton,
  VoidCallback onCancel,
  bool needThirdButton,
  String thirdButtonText,
  VoidCallback onThirdButtonPressed,
}) async {
  FocusScope.of(context).requestFocus(FocusNode());
  message ??= Strings.commonError;
  cancelButtonText ??= Strings.cancel;
  submitButtonText ??= Strings.retry;
  needCancelButton ??= true;
  onCancel ??= () => null;
  needThirdButton ??= false;
  thirdButtonText ??= '';
  onThirdButtonPressed ??= () => null;

  final thirdButton = _buildDialogButton(
    thirdButtonText,
    onThirdButtonPressed,
  );

  final cancelButton = _buildDialogButton(
    cancelButtonText,
    onCancel,
  );

  final continueButton = _buildDialogButton(
    submitButtonText,
    onSubmit ?? () {},
  );

  final actions = [continueButton];
  if (needCancelButton) {
    actions.insert(0, cancelButton);
  }
  if (needThirdButton) {
    actions.insert(1, thirdButton);
  }

  final alert = AlertDialog(
    title: title != null ? Text(title) : null,
    content: Text(message),
    actions: actions,
  );

  return await showDialog<dynamic>(
    context: context,
    builder: (context) => alert,
  );
}

Widget _buildDialogButton(String text, VoidCallback onPressed) {
  return FlatButton(
    onPressed: () {
      appRouter.goBack();
      onPressed();
    },
    child: Text(text, style: _buttonsStyle),
  );
}

const _buttonsStyle = TextStyle(
  color: ColorRes.blue,
  fontWeight: FontWeight.normal,
  fontFamily: 'SFPro',
  fontStyle: FontStyle.normal,
  fontSize: 14.0,
);
