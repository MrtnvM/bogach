import 'dart:ui';

import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';

Future<DialogResponse> showCashDialog({
  @required BuildContext context,
  @required String title,
  @required String message,
  String positiveButton,
  String negativeButton,
  bool displayPositive = true,
  bool displayNegative = true,
  bool barrierDismissible = true,
}) {
  return showDialog<DialogResponse>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: <Widget>[
                    if (displayPositive)
                      Expanded(
                        child: Container(
                          child: FlatButton(
                            child: Text(positiveButton ?? Strings.confirm),
                            onPressed: () {
                              Navigator.pop(context, DialogResponse.confirm);
                            },
                          ),
                        ),
                      ),
                    if (displayPositive && displayNegative)
                      const SizedBox(width: 19),
                    if (displayNegative)
                      Expanded(
                        child: FlatButton(
                          child: Text(negativeButton ?? Strings.cancel),
                          onPressed: () {
                            Navigator.pop(context, DialogResponse.decline);
                          },
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

void handleError({
  @required BuildContext context,
  @required dynamic exception,
  VoidCallback onRetry,
  String errorMessage,
  bool barrierDismissible = true,
  bool displayNegative = true,
}) {
  switch (exception.runtimeType) {
    case NetworkConnectionException:
      showErrorDialog(
        context: context,
        message: Strings.noInternetError,
        onRetry: onRetry,
        barrierDismissible: barrierDismissible,
        displayNegative: displayNegative,
      );
      break;
    case PlatformException:
      if (exception.code == 'ERROR_NETWORK_REQUEST_FAILED') {
        showErrorDialog(
          context: context,
          message: Strings.noInternetError,
          onRetry: onRetry,
          barrierDismissible: barrierDismissible,
          displayNegative: displayNegative,
        );
      } else {
        showErrorDialog(
          context: context,
          onRetry: onRetry,
          barrierDismissible: barrierDismissible,
          displayNegative: displayNegative,
        );
      }
      break;

    default:
      if (errorMessage?.isNotEmpty == true) {
        showErrorDialog(
          context: context,
          message: errorMessage,
          onRetry: onRetry,
          barrierDismissible: barrierDismissible,
          displayNegative: displayNegative,
        );
      } else {
        showErrorDialog(
          context: context,
          onRetry: onRetry,
          barrierDismissible: barrierDismissible,
          displayNegative: displayNegative,
        );
      }
      break;
  }
}

Future<void> showErrorDialog({
  @required BuildContext context,
  String title = Strings.warning,
  String message = Strings.commonError,
  VoidCallback onRetry,
  bool barrierDismissible = true,
  bool displayNegative = true,
}) async {
  final response = await showCashDialog(
    context: context,
    title: title,
    message: message,
    negativeButton: Strings.cancel,
    positiveButton: onRetry != null ? Strings.retry : null,
    displayPositive: onRetry != null,
    displayNegative: displayNegative,
    barrierDismissible: barrierDismissible,
  );

  if (response == DialogResponse.confirm && onRetry != null) {
    onRetry();
  }
}

enum DialogResponse { confirm, decline, cancel }
