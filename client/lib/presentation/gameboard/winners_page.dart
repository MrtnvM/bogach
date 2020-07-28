import 'dart:math';

import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/winners_page_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WinnersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final monthNumber = useGlobalState(
      (s) => max(s.game.currentGame.state.monthNumber - 1, 0),
    );

    final userId = useUserId();
    final isWin = useCurrentGame(
      (g) {
        final participantProgress = g.state.participantsProgress[userId];
        return participantProgress.progress >= 1;
      },
    );

    final startAgain = useGameRestarter();

    return Container(
      color: ColorRes.mainGreen,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 180,
              width: 180,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(isWin ? Images.win : Images.fail),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              isWin ? Strings.winnersPageTitle : Strings.gameFailedPageTitle,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              isWin
                  ? Strings.winnersPageDescription
                  : Strings.gameFailedPageDescription,
              style: const TextStyle(fontSize: 17, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (isWin) ...[
              const SizedBox(height: 8),
              Text(
                '$monthNumber ${Strings.months(monthNumber)}',
                style: Styles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
            const SizedBox(height: 54),
            if (isWin) ...[
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: ColorButton(
                  color: ColorRes.yellow,
                  text: Strings.goToMainMenu,
                  onPressed: appRouter.goToRoot,
                ),
              ),
            ] else ...[
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: ColorButton(
                  color: ColorRes.yellow,
                  text: Strings.startAgain,
                  onPressed: startAgain,
                ),
              ),
              const SizedBox(height: 16),
              RaisedButton(
                onPressed: appRouter.goToRoot,
                child: Text(Strings.goToMainMenu),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
