import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';

class BuySellBar extends StatelessWidget {
  const BuySellBar({
    Key key,
    this.selectedAction = const BuySellAction.buy(),
    this.onActionChanged,
  })  : assert(selectedAction != null),
        super(key: key);

  final BuySellAction selectedAction;
  final void Function(BuySellAction) onActionChanged;

  @override
  Widget build(BuildContext context) {
    const buyAction = BuySellAction.buy();
    const sellAction = BuySellAction.sell();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(width: 8),
        _buildBarButton(
          context,
          action: buyAction,
          selectedAction: selectedAction,
          onSelected: () => onActionChanged(buyAction),
        ),
        _buildBarButton(
          context,
          action: sellAction,
          selectedAction: selectedAction,
          onSelected: () => onActionChanged(sellAction),
        ),
      ],
    );
  }

  Widget _buildBarButton(
    BuildContext context, {
    @required BuySellAction action,
    @required BuySellAction selectedAction,
    @required VoidCallback onSelected,
  }) {
    final theme = Theme.of(context).copyWith(
      unselectedWidgetColor: action.map(
        buy: (_) => ColorRes.green,
        sell: (_) => ColorRes.orange,
      ),
    );

    final title = action.map(
      buy: (_) => Strings.purchasing,
      sell: (_) => Strings.selling,
    );

    final radioButtonColor = action.map(
      buy: (_) => ColorRes.green,
      sell: (_) => ColorRes.orange,
    );

    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        color: action == selectedAction
            ? ColorRes.grey2
            : ColorRes.scaffoldBackground,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Theme(
              data: theme,
              child: Radio(
                value: selectedAction,
                groupValue: action,
                onChanged: (_) => onSelected(),
                activeColor: radioButtonColor,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
