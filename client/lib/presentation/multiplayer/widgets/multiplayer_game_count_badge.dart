import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/purchases/games_access_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultiplayerGameCountBadge extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final availableGamesCount = useAvailableMultiplayerGamesCount();
    const badgeHeight = 36.0;

    return GestureDetector(
      onTap: () => appRouter.goTo(const GamesAccessPage()),
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
            Image.asset(Images.multiplayerBadge, height: 24, width: 24),
            const SizedBox(width: 8),
            Text(
              '${Strings.multiplayerGamesAvailable}  ',
              style: Styles.bodyBlack.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                '$availableGamesCount',
                style: Styles.bodyBlack.copyWith(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
