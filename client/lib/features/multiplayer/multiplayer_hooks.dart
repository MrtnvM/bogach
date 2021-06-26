import 'dart:math';

import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';

int? useAvailableMultiplayerGamesCount() {
  final availableGamesCount = useGlobalState((s) {
    final currentUser = s.profile.currentUser;
    return getAvailableMultiplayerGamesCount(currentUser);
  });

  return availableGamesCount;
}

int getAvailableMultiplayerGamesCount(UserProfile? user) {
  final boughtGamesCount =
      user?.purchaseProfile?.boughtMultiplayerGamesCount ?? 0;
  final gamesPlayed = user?.playedGames?.multiplayerGames.length ?? 0;

  final availableGamesCount = max(boughtGamesCount - gamesPlayed, 0);
  return availableGamesCount;
}
