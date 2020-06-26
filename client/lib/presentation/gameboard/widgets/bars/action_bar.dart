import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
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
      height: 49,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 3,
            spreadRadius: 3,
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
                color: takeLoan != null ? ColorRes.white : ColorRes.mainGreen,
                text: Strings.confirm,
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
    String text,
    Function() onPressed,
  }) {
    return RaisedButton(
      onPressed: onPressed,
      elevation: 0,
      color: color,
      padding: const EdgeInsets.all(0),
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints.expand(),
        child: AutoSizeText(
          text,
          minFontSize: 10,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: Styles.bodyBlack.copyWith(
            fontSize: 13,
            color: color == ColorRes.white ? ColorRes.black : ColorRes.white,
          ),
        ),
      ),
    );
  }
}
