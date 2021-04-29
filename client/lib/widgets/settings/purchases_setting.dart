import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/purchases/purchase_list.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';

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

class _PurchasesSettingState extends State<PurchasesSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.green.withAlpha(240),
        ),
        onPressed: openPurchases,
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
      ),
    );
  }

  void openPurchases() {
    appRouter.goTo(const PurchaseListPage());
  }
}
