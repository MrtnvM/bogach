import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TotalInfoWidget extends HookWidget {
  const TotalInfoWidget({required this.totalPrice});

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            Strings.total,
            style: Styles.infoBlockValue.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          totalPrice.toPriceWithoutSymbol(),
          style: Styles.infoBlockValue.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          ' ${Strings.rubleSymbol}',
          style: Styles.infoBlockDescription,
        )
      ],
    );
  }
}
