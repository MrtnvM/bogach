import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BuySellBar extends HookWidget {
  const BuySellBar({Key key, this.onActionChanged}) : super(key: key);

  final void Function(BuySellAction) onActionChanged;

  @override
  Widget build(BuildContext context) {
    const buyAction = BuySellAction.buy();
    const sellAction = BuySellAction.sell();

    final action = useState(const BuySellAction.buy());

    useValueChanged(action.value, (oldValue, oldResult) {
      onActionChanged(action.value);
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(width: 8),
        _buildBarButton(
          context,
          action: buyAction,
          selectedAction: action.value,
          onSelected: () => action.value = buyAction,
        ),
        _buildBarButton(
          context,
          action: sellAction,
          selectedAction: action.value,
          onSelected: () => action.value = sellAction,
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
