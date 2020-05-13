import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/resources/colors.dart';
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
              child: _ActionButton(
                color: Colors.orange,
                text: Strings.takeLoan,
                maxTitleLines: 2,
                onPressed: takeLoan,
              ),
            ),
            const SizedBox(width: 9),
          ],
          Expanded(
            child: _ActionButton(
              color: Colors.green,
              text: Strings.confirm,
              maxTitleLines: 1,
              onPressed: confirm,
            ),
          ),
          if (skip != null) ...[
            const SizedBox(width: 9),
            Expanded(
              child: _ActionButton(
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    this.text,
    this.color,
    this.maxTitleLines,
    this.onPressed,
  });

  final String text;
  final Color color;
  final int maxTitleLines;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      color: color,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints.expand(),
        child: AutoSizeText(
          text,
          minFontSize: 10,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          maxLines: maxTitleLines,
          style: TextStyle(
            color: ColorRes.primaryWhiteColor,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
