import 'dart:math';

import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/winners_page_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WinnersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isWin = useIsCurrentParticipantWinGame();
    final isMultiplayer = useIsMultiplayerGame();
    final isQuest = useIsQuestGame();
    final gameExists = useCurrentGame((g) => g != null);

    if (!gameExists) {
      return LoadableView(
        isLoading: !gameExists,
        backgroundColor: ColorRes.white,
        indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
        child: Container(),
      );
    }

    return Container(
      color: ColorRes.mainGreen,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _HeadlineImage(isWin: isWin),
            const SizedBox(height: 40),
            _HeadlineTitle(isWin: isWin),
            const SizedBox(height: 24),
            _HeadlineDescription(isWin: isWin),
            if (isWin && !isMultiplayer) _MonthCountDescription(),
            if (isMultiplayer) ...[
              const SizedBox(height: 24),
              _PlayerResultTable(),
            ],
            const SizedBox(height: 54),
            if (isWin) ...[
              if (isQuest) ...[
                _GoToQuestsButton(),
                const SizedBox(height: 16),
              ],
              _GoToMainMenuButton(),
            ] else ...[
              if (!isMultiplayer) ...[
                _StartAgainButton(),
                const SizedBox(height: 16),
              ],
              _GoToMainMenuButton(),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoToQuestsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: ColorButton(
        color: ColorRes.yellow,
        text: Strings.goToQuests,
        onPressed: appRouter.goBack,
      ),
    );
  }
}

class _GoToMainMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: ColorButton(
        color: ColorRes.white,
        text: Strings.goToMainMenu,
        onPressed: appRouter.goToRoot,
      ),
    );
  }
}

class _StartAgainButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final startAgain = useGameRestarter();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: ColorButton(
        color: ColorRes.yellow,
        text: Strings.startAgain,
        onPressed: startAgain,
      ),
    );
  }
}

class _MonthCountDescription extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final monthNumber = useGlobalState(
      (s) => max(s.game.currentGame.state.monthNumber - 1, 0),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Text(
          '$monthNumber ${Strings.months(monthNumber)}',
          style: Styles.caption.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

class _HeadlineDescription extends StatelessWidget {
  const _HeadlineDescription({@required this.isWin, Key key}) : super(key: key);

  final bool isWin;

  @override
  Widget build(BuildContext context) {
    return Text(
      isWin
          ? Strings.winnersPageDescription
          : Strings.gameFailedPageDescription,
      style: const TextStyle(fontSize: 17, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}

class _HeadlineTitle extends StatelessWidget {
  const _HeadlineTitle({@required this.isWin, Key key}) : super(key: key);

  final bool isWin;

  @override
  Widget build(BuildContext context) {
    return Text(
      isWin ? Strings.winnersPageTitle : Strings.gameFailedPageTitle,
      style: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _HeadlineImage extends StatelessWidget {
  const _HeadlineImage({@required this.isWin, Key key}) : super(key: key);

  final bool isWin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image.asset(isWin ? Images.win : Images.fail),
      ),
    );
  }
}

class _PlayerResultTable extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final participants = useGlobalState((g) {
      final game = g.game.currentGame;
      final userProfiles = g.multiplayer.userProfiles;
      final participants = game.participantsIds //
          .map((id) => userProfiles.itemsMap[id])
          .toList();

      participants.sort((p1, p2) {
        final target1 = mapGameToCurrentTargetValue(game, p1.userId);
        final target2 = mapGameToCurrentTargetValue(game, p2.userId);
        return target1 > target2 ? 0 : 1;
      });

      return participants;
    });

    final game = useGlobalState((g) => g.game.currentGame);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < participants.length; i++)
            _buildParticipant(i, participants[i], game),
        ],
      ),
    );
  }

  Widget _buildParticipant(int index, UserProfile participant, Game game) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 5),
              ],
            ),
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              (index + 1).toString(),
              style: Styles.body1.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              participant.fullName,
              maxLines: 2,
              style: Styles.body1.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            mapGameToCurrentTargetStringValue(game, participant.userId),
            style: Styles.body1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
