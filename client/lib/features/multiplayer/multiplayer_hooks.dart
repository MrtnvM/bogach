import 'dart:math';

import 'package:cash_flow/core/hooks/global_state_hook.dart';

int useAvailableMultiplayerGamesCount() {
  final boughtGamesCount = useGlobalState((s) {
    final currentUser = s.profile.currentUser;
    return currentUser?.purchaseProfile?.boughtMultiplayerGamesCount ?? 0;
  });

  final gamesPlayed = useGlobalState((s) {
    final currentUser = s.profile.currentUser;
    return currentUser?.multiplayerGamePlayed ?? 0;
  });

  final availableGamesCount = max(boughtGamesCount - gamesPlayed, 0);
  return availableGamesCount;
}
