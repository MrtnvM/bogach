import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/table_divider.dart';
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
    final activeGameState = useGlobalState((s) => s.game.activeGameState);

    final waitingPlayerList = activeGameState.maybeWhen(
      waitingPlayers: (ids) => ids.map((id) => userProfiles.itemsMap[id]),
      orElse: () => [],
    );

    return CardContainer(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          const TableDivider(),
          const SizedBox(height: 4),
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              for (final profile in waitingPlayerList)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            style: Styles.tableHeaderTitleBlue,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
