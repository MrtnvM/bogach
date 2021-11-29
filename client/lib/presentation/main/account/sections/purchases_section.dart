import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/main/account/widgets/restore_purchases_button.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PurchasesSection extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          text: Strings.purchaseSectionTitle,
          padding: EdgeInsets.only(
            left: size(16),
            bottom: size(16),
            top: size(8),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: size(16),
            right: size(16),
            bottom: size(16),
          ),
          child: const RestorePurchasesButton(),
        ),
      ],
    );
  }
}
