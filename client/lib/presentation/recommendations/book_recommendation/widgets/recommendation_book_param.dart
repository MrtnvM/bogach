import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationBookParam extends HookWidget {
  const RecommendationBookParam({
    required this.icon,
    required this.title,
    required this.paramValue,
  });

  final IconData icon;
  final String title;
  final String paramValue;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: size(14)),
            SizedBox(width: size(4)),
            Text(
              paramValue,
              style: Styles.bodyBlackBold,
            ),
          ],
        ),
        SizedBox(width: size(4)),
        Text(
          title,
          style: Styles.bodyBlack.copyWith(color: Colors.grey),
        )
      ],
    );
  }
}
