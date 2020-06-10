import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/user_profile_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WaitingPlayersCard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userProfiles = useGlobalState((s) => s.game.participantProfiles);
    final participantIds = useCurrentGame((g) => g.participants);
    final participantsStatus = useCurrentGame(
      (g) => g.state.participantsProgress,
    );

    final waitingPlayerList = participantIds
        .where((id) =>
            participantsStatus[id].status !=
            ParticipantProgressStatus.monthResult)
        .map((id) => userProfiles.itemsMap[id]);

    return CardContainer(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              for (final profile in waitingPlayerList)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserProfileItem(
                    profile,
                    titleColor: ColorRes.mainBlack,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            Strings.waitingPlayersList,
            style: Styles.tableHeaderTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
