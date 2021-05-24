import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Badge extends HookWidget {
  const Badge({
    required this.title,
    required this.imageAsset,
    this.onTap,
    Key? key,
  })  : super(key: key);

  final String title;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final badgeHeight = size(32);
    final iconSize = size(20);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: badgeHeight,
        decoration: BoxDecoration(
          color: ColorRes.mainGreen.withAlpha(10),
          borderRadius: BorderRadius.all(
            Radius.circular(badgeHeight / 2),
          ),
          border: Border.all(
            color: ColorRes.mainGreen.withAlpha(80),
            width: 1,
          ),
        ),
        padding: EdgeInsets.only(
          top: size(4),
          bottom: size(4),
          left: size(14),
          right: size(14),
        ),
        margin: EdgeInsets.only(bottom: size(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageAsset, height: iconSize, width: iconSize),
            SizedBox(width: size(8)),
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 1.5),
              child: Text(title, style: Styles.badgeContent),
            ),
          ],
        ),
      ),
    );
  }
}
