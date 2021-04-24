import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/game_event_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ActionsTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = useIsGameboardActionInProgress();
    final scrollController = useScrollController();
    final activeGameState = useCurrentActiveGameState();

    final currenEventIndex = activeGameState.maybeWhen(
      gameEvent: (eventIndex, sendingEventIndex) => eventIndex,
      orElse: () => -1,
    );

    useEffect(() {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }

      return null;
    }, [currenEventIndex]);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                children: const [
                  GameEventPage(),
                ],
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorRes.mainGreen),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

bool useIsGameboardActionInProgress() {
  final gameId = useCurrentGameId();
  final isActionInProgress = useGlobalState((s) {
    final activeGameState = s.game.activeGameStates[gameId];
    final isStartingNewMonth =
        s.getOperationState(Operation.startNewMonth).isInProgress;

    final isSendingTurnEvent = activeGameState.maybeWhen(
      gameEvent: (eventIndex, sendingEventIndex) =>
          eventIndex == sendingEventIndex,
      orElse: () => false,
    );

    return isSendingTurnEvent || isStartingNewMonth;
  });

  return isActionInProgress;
}
