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
    required this.onActionChanged,
    this.canSell = false,
  }) : super(key: key);

  final BuySellAction selectedAction;
  final OnActionChangedCallback onActionChanged;
  final bool canSell;

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
          onSelected: () => onActionChanged(buyAction),
          isEnabled: true,
          color: ColorRes.mainGreen,
        ),
        _buildBarButton(
          context,
          action: sellAction,
          selectedAction: selectedAction,
          onSelected: () => onActionChanged(sellAction),
          isEnabled: canSell,
          color: ColorRes.mainRed,
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
    required Color color,
  }) {
    final title = action.map(
      buy: (_) => Strings.purchasing,
      sell: (_) => Strings.selling,
    );

    final isSelected = action == selectedAction;
    final isBuyAction = action == const BuySellAction.buy();
    final isSellAction = action == const BuySellAction.sell();

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected && isEnabled) {
            onSelected();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: isSelected ? 0 : 6),
          child: Container(
            height: isSelected ? 50 : 44,
            decoration: BoxDecoration(
              color: isEnabled
                  ? color.withAlpha(isSelected ? 255 : 180)
                  : ColorRes.grey2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(!isSelected && isSellAction ? 0 : 8),
                topRight: Radius.circular(!isSelected && isBuyAction ? 0 : 8),
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: Styles.body1.copyWith(
                    color: isEnabled ? Colors.white : Colors.grey,
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
      ),
    );
  }
}
