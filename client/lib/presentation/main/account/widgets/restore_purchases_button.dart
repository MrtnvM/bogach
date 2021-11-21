import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/purchase/actions/restore_purchases_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RestorePurchasesButton extends HookWidget {
  const RestorePurchasesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();
    final size = useAdaptiveSize();

    final restorePurchases = () async {
      try {
        await dispatch(RestorePurchasesAction());
        showAlert(
          context: context,
          title: Strings.purchasesRestoredAlertTitle,
          message: Strings.purchasesRestoredAlertMessage,
        );
      } catch (error) {
        showWarningAlertDialog(
          context: context,
          errorMessage: Strings.restorePurchasesError,
        );
      }
    };

    return OutlinedButton(
      onPressed: restorePurchases,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size(12)),
        child: Text(Strings.restorePurchases),
      ),
    );
  }
}
