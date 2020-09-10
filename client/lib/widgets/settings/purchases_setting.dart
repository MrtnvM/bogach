import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/purchases/purchase_list.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class PurchasesSetting extends StatefulWidget implements ControlPanelSetting {
  const PurchasesSetting();

  @override
  _PurchasesSettingState createState() => _PurchasesSettingState();

  @override
  Setting get setting => Setting(
        id: runtimeType.toString(),
        title: 'Purchases',
      );
}

class _PurchasesSettingState extends State<PurchasesSetting> with ReduxState {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: RaisedButton(
        color: Colors.green.withAlpha(240),
        child: FittedBox(
          child: Text(
            'Purchases',
            style: TextStyle(
              color: Colors.white.withAlpha(240),
              letterSpacing: 0.4,
              fontSize: 14,
            ),
          ),
        ),
        onPressed: openPurchases,
      ),
    );
  }

  void openPurchases() {
    appRouter.goTo(const PurchaseListPage());
  }
}
