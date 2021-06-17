import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:flutter/material.dart';

class PlayerActionBar extends StatelessWidget {
  const PlayerActionBar({
    Key? key,
    required this.confirm,
    this.takeLoan,
    this.skip,
    this.buySellAction,
  }) : super(key: key);

  final VoidCallback confirm;
  final VoidCallback? takeLoan;
  final VoidCallback? skip;
  final BuySellAction? buySellAction;

  @override
  Widget build(BuildContext context) {
    final gameTutorial = GameboardTutorialWidget.of(context);

    return Container(
      key: gameTutorial?.gameEventActionsKey,
      height: 49,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withAlpha(10),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 5,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Row(
          children: [
            if (takeLoan != null)
              Expanded(
                child: _actionBarItem(
                  color: ColorRes.mainGreen,
                  text: Strings.takeLoan,
                  onPressed: takeLoan,
                ),
              ),
            Expanded(
              child: _actionBarItem(
                color: buySellAction == const BuySellAction.sell()
                    ? ColorRes.mainRed
                    : ColorRes.mainGreen,
                text: buySellAction != null
                    ? buySellAction == const BuySellAction.buy()
                        ? Strings.buy
                        : Strings.sell
                    : Strings.ok,
                onPressed: confirm,
              ),
            ),
            if (skip != null) ...[
              if (takeLoan != null)
                Container(
                  width: 1,
                  height: double.infinity,
                  color: ColorRes.newGameBoardConditionDividerColor,
                ),
              Expanded(
                child: _actionBarItem(
                  text: Strings.skip,
                  onPressed: skip,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionBarItem({
    Color color = ColorRes.white,
    required String text,
    Function()? onPressed,
  }) {
    return AnimatedContainer(
      color: color,
      duration: const Duration(milliseconds: 50),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          padding: const EdgeInsets.all(0),
          elevation: 0,
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints.expand(),
          child: AutoSizeText(
            text,
            minFontSize: 11,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Styles.bodyBlack.copyWith(
              fontSize: 14.5,
              color: color == ColorRes.white ? ColorRes.black : ColorRes.white,
            ),
          ),
        ),
      ),
    );
  }
}
