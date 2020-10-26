import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    this.title,
    this.titleWidget,
    this.imageUrl,
    this.imageAsset,
    this.onTap,
    Key key,
  })  : assert(imageUrl != null || imageAsset != null),
        super(key: key);

  final String imageAsset;
  final String imageUrl;
  final String title;
  final Widget titleWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const badgeHeight = 36.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: badgeHeight,
        decoration: BoxDecoration(
          color: ColorRes.mainGreen,
          borderRadius: const BorderRadius.all(
            Radius.circular(badgeHeight / 2),
          ),
          border: Border.all(
            color: Colors.white.withAlpha(150),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 3),
          ],
        ),
        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 18),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset, height: 24, width: 24),
            if (imageUrl != null && imageAsset == null)
              Image.network(imageUrl, height: 24, width: 24),
            const SizedBox(width: 8),
            if (title != null)
              Text(
                title,
                style: Styles.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (titleWidget != null && title == null) titleWidget,
          ],
        ),
      ),
    );
  }
}
