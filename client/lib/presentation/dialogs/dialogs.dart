import 'dart:ui';

import 'package:cash_flow/models/errors/domain_game_error.dart';
import 'package:cash_flow/models/errors/past_purchase_error.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void showNotImplementedDialog(BuildContext context) {
  showCashDialog(
    context: context,
    title: Strings.notImpelementedAlertTitle,
    message: Strings.notImpelementedAlertMessage,
    displayNegative: false,
  );
}

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
      builder: (context) {
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
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context, DialogResponse.confirm);
                          },
                          child: Text(positiveButton ?? Strings.ok),
                        ),
                      ),
                    if (displayPositive && displayNegative)
                      const SizedBox(width: 19),
                    if (displayNegative)
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context, DialogResponse.decline);
                          },
                          child: Text(negativeButton ?? Strings.cancel),
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
  if (exception is DomainGameError) {
    final scaffold = Scaffold.of(context);
    final locale = Intl.defaultLocale;
    final errorMessage = exception.message[locale] ?? Strings.commonError;

    scaffold.showSnackBar(SnackBar(
      content: Text(errorMessage),
      action: SnackBarAction(
        label: Strings.ok,
        textColor: ColorRes.lightGreen,
        onPressed: () => null,
      ),
    ));
    return;
  }

  if (exception is FirebaseAuthException) {
    showErrorDialog(
      context: context,
      message: Strings.cannotAuthoriseThroughSocial,
      onRetry: onRetry,
      barrierDismissible: barrierDismissible,
      displayNegative: displayNegative,
    );
    return;
  }

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

    case PastPurchaseError:
      showErrorDialog(
        context: context,
        message: Strings.restorePurchasesError,
        onRetry: onRetry,
        barrierDismissible: barrierDismissible,
        displayNegative: displayNegative,
      );
      break;

    case PlatformException:
      String errorMessage;

      switch (exception.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          errorMessage = Strings.noInternetError;
          break;
      }

      showErrorDialog(
        context: context,
        message: errorMessage,
        onRetry: onRetry,
        barrierDismissible: barrierDismissible,
        displayNegative: displayNegative,
      );
      break;

    default:
      final message = errorMessage?.isNotEmpty == true ? errorMessage : null;

      showErrorDialog(
        context: context,
        message: message,
        onRetry: onRetry,
        barrierDismissible: barrierDismissible,
        displayNegative: displayNegative,
      );
      break;
  }
}

Future<void> showErrorDialog({
  @required BuildContext context,
  String title,
  String message,
  VoidCallback onRetry,
  bool barrierDismissible = true,
  bool displayNegative = true,
}) async {
  final response = await showCashDialog(
    context: context,
    title: title ?? Strings.warning,
    message: message ?? Strings.commonError,
    negativeButton: onRetry != null ? Strings.cancel : Strings.ok,
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
