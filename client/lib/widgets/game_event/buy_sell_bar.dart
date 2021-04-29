import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

typedef OnActionChangedCallback = void Function(BuySellAction);

class BuySellBar extends StatelessWidget {
  const BuySellBar({
    Key? key,
    this.selectedAction = const BuySellAction.buy(),
    this.onActionChanged,
    this.canSell,
  })  : super(key: key);

  final BuySellAction selectedAction;
  final OnActionChangedCallback? onActionChanged;
  final bool? canSell;

  @override
  Widget build(BuildContext context) {
    const buyAction = BuySellAction.buy();
    const sellAction = BuySellAction.sell();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildBarButton(
          context,
          action: buyAction,
          selectedAction: selectedAction,
          onSelected: () => onActionChanged!(buyAction),
          isEnabled: true,
        ),
        _buildBarButton(
          context,
          action: sellAction,
          selectedAction: selectedAction,
          onSelected: () => onActionChanged!(sellAction),
          isEnabled: canSell!,
        ),
      ],
    );
  }

  Widget _buildBarButton(
    BuildContext context, {
    required BuySellAction action,
    required BuySellAction selectedAction,
    required VoidCallback onSelected,
    required bool isEnabled,
  }) {
    final title = action.map(
      buy: (_) => Strings.purchasing,
      sell: (_) => Strings.selling,
    );

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (action != selectedAction && isEnabled) {
            onSelected();
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: _getBarColor(
              isEnabled: isEnabled,
              isSelected: action == selectedAction,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: Styles.body1.copyWith(
                  color: _getBarTextColor(isEnabled),
                  fontSize: 16,
                  fontWeight: action == selectedAction
                      ? FontWeight.w700
                      : FontWeight.w500,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBarColor({bool? isEnabled, required bool isSelected}) {
    if (isSelected) {
      return ColorRes.mainGreen;
    }

    if (!isEnabled!) {
      return ColorRes.grey2;
    }

    return ColorRes.lightGreen;
  }

  Color _getBarTextColor(bool isEnabled) {
    return isEnabled ? Colors.white : Colors.grey;
  }
}
