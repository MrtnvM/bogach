import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/purchases/games_access_page.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/widgets/containers/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultiplayerGameCountBadge extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final availableGamesCount = useAvailableMultiplayerGamesCount();

    return Badge(
      title: '$availableGamesCount',
      imageAsset: Images.multiplayerBadge,
      onTap: () => appRouter.goTo(const GamesAccessPage()),
    );
  }
}
