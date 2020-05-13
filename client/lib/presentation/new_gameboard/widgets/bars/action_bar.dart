import 'package:cash_flow/presentation/new_gameboard/widgets/action_button.dart';
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
      height: 46,
      child: Row(
        children: [
          if (takeLoan != null) ...[
            Expanded(
              child: ActionButton(
                color: Colors.orange,
                text: Strings.takeLoan,
                maxTitleLines: 2,
                onPressed: takeLoan,
              ),
            ),
            const SizedBox(width: 9),
          ],
          Expanded(
            child: ActionButton(
              color: Colors.green,
              text: Strings.confirm,
              maxTitleLines: 1,
              onPressed: confirm,
            ),
          ),
          if (skip != null) ...[
            const SizedBox(width: 9),
            Expanded(
              child: ActionButton(
                color: Colors.grey,
                text: Strings.skip,
                maxTitleLines: 1,
                onPressed: skip,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
