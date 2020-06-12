import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar_button.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';

class PlayerActionBar extends StatelessWidget {
  const PlayerActionBar({
    Key key,
    @required this.confirm,
    this.takeLoan,
    this.skip,
  }) : super(key: key);

  final VoidCallback confirm;
  final VoidCallback takeLoan;
  final VoidCallback skip;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          if (takeLoan != null) ...[
            Expanded(
              child: ActionBarButton(
                color: Colors.orange,
                text: Strings.takeLoan,
                maxTitleLines: 2,
                onPressed: takeLoan,
              ),
            ),
            const SizedBox(width: 9),
          ],
          Expanded(
            child: ActionBarButton(
              color: Colors.green,
              text: Strings.confirm,
              onPressed: confirm,
            ),
          ),
          if (skip != null) ...[
            const SizedBox(width: 9),
            Expanded(
              child: ActionBarButton(
                color: Colors.grey,
                text: Strings.skip,
                onPressed: skip,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
