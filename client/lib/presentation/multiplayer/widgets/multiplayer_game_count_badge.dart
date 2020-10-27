import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/purchases/games_access_page.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultiplayerGameCountBadge extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final availableGamesCount = useAvailableMultiplayerGamesCount();

    return Badge(
      onTap: () => appRouter.goTo(const GamesAccessPage()),
      imageAsset: Images.multiplayerBadge,
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${Strings.multiplayerGamesAvailable}  ',
            style: Styles.body1.copyWith(
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
    );
  }
}
