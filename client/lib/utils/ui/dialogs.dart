import 'package:app_settings/app_settings.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';

void showWarningAlertDialog({
  required BuildContext context,
  String? errorMessage,
  String? submitButtonText,
  VoidCallback? onSubmit,
  bool? needCancelButton,
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
  required BuildContext context,
  String? title,
  String? message,
  VoidCallback? onSubmit,
  String? cancelButtonText,
  String? submitButtonText,
  bool? needCancelButton,
  VoidCallback? onCancel,
  bool? needThirdButton,
  String? thirdButtonText,
  VoidCallback? onThirdButtonPressed,
}) async {
  FocusScope.of(context).requestFocus(FocusNode());
  message ??= Strings.commonError;
  cancelButtonText ??= Strings.cancel;
  submitButtonText ??= Strings.retry;
  needCancelButton ??= true;
  onCancel ??= () {};
  needThirdButton ??= false;
  thirdButtonText ??= '';
  onThirdButtonPressed ??= () {};

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
  return TextButton(
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

enum NoAccessMode { gallery, camera }

void showDialogGoToAppSettings(BuildContext context, NoAccessMode mode) {
  late String title;
  late String message;

  switch (mode) {
    case NoAccessMode.gallery:
      title = Strings.noGalleryAccessTitle;
      message = Strings.noGalleryAccessMessage;
      break;

    case NoAccessMode.camera:
      title = Strings.noCameraAccessTitle;
      message = Strings.noCameraAccessMessage;
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: AppSettings.openAppSettings,
            child: Text(Strings.goToSettings),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(Strings.cancel),
          )
        ],
      );
    },
  );
}
