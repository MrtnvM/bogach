import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationsHeader extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();
    final avatarSize = size(60);

    return MediaQuery(
      data: mediaQuery,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size(16),
          horizontal: size(22),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.withAlpha(100),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: CircleAvatar(
                backgroundImage: const AssetImage(Images.borodachAvatar),
                backgroundColor: Colors.transparent,
                radius: avatarSize / 2,
              ),
            ),
            SizedBox(width: size(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.recommendationsTitle,
                    style: Styles.body1.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: size(16),
                    ),
                  ),
                  Text(
                    Strings.recommendationsDescription,
                    style: Styles.body1.copyWith(
                      color: Colors.black.withAlpha(170),
                      fontWeight: FontWeight.normal,
                      fontSize: size(13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
