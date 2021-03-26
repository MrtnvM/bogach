import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SectionTitle extends HookWidget {
  const SectionTitle({
    @required this.text,
    this.actionWidget,
    this.padding,
  }) : assert(text != null);

  final String text;
  final Widget actionWidget;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();

    return MediaQuery(
      data: mediaQuery,
      child: Padding(
        padding: padding ?? EdgeInsets.only(left: size(20), right: size(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: Styles.head.copyWith(color: ColorRes.black),
              ),
            ),
            if (actionWidget != null) ...[
              SizedBox(width: size(16)),
              actionWidget,
            ]
          ],
        ),
      ),
    );
  }
}
