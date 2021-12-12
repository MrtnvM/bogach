import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SectionDescription extends HookWidget {
  const SectionDescription({
    required this.text,
    this.padding,
  });

  final String text;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();

    return MediaQuery(
      data: mediaQuery,
      child: Padding(
        padding: padding ??
            EdgeInsets.only(
              left: size(20),
              right: size(16),
              top: size(10),
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: Styles.subhead.copyWith(
                  color: Colors.black54,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
