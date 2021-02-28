import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    @required this.title,
    @required this.imageAsset,
    this.onTap,
    Key key,
  })  : assert(title != null),
        assert(imageAsset != null),
        super(key: key);

  final String title;
  final String imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const badgeHeight = 32.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: badgeHeight,
        decoration: BoxDecoration(
          color: ColorRes.mainGreen.withAlpha(10),
          borderRadius: const BorderRadius.all(
            Radius.circular(badgeHeight / 2),
          ),
          border: Border.all(
            color: ColorRes.mainGreen.withAlpha(80),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 14, right: 14),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageAsset, height: 20, width: 20),
            const SizedBox(width: 8),
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
