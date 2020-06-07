import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/user_profile_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class RoomPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final room = useGlobalState((s) => s.multiplayer.currentRoom);
    final userProfiles = useGlobalState((s) => s.multiplayer.userProfiles);
    final isActionInProgress = useGlobalState(
      (s) =>
          s.multiplayer.createRoomGameRequestState.isInProgress ||
          s.multiplayer.setPlayerReadyRequestState.isInProgress,
    );

    final multiplayerActions = useMultiplayerActions();
    final gameActions = useGameActions();

    useEffect(() {
      if (room?.gameId != null) {
        gameActions.startGame(room.gameId);

        Future.delayed(const Duration(milliseconds: 100)).then((_) async {
          appRouter.goToRoot();
          appRouter.goTo(GameBoard());

          multiplayerActions.stopListeningRoomUpdates(room.id);
        });
      }

      return null;
    }, [room?.gameId]);

    return Loadable(
      backgroundColor: ColorRes.black80,
      isLoading: isActionInProgress,
      child: CashFlowScaffold(
        title: Strings.waitingPlayers,
        showUser: true,
        child: Container(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (final participant in room?.participants ?? [])
                    UserProfileItem(userProfiles.itemsMap[participant.id])
                ],
              ),
              const SizedBox(height: 36),
              if (room?.owner?.id == userId)
                _buildStartGameButton(
                  startGame: multiplayerActions.createRoomGame,
                )
              else
                _buildReadyButton(
                  join: () => multiplayerActions.setPlayerReady(userId),
                ),
              const SizedBox(height: 16),
              _buildBackButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartGameButton({
    VoidCallback startGame,
  }) {
    return Container(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.startGame,
        onPressed: startGame,
        color: ColorRes.white,
      ),
    );
  }

  Widget _buildReadyButton({
    VoidCallback join,
  }) {
    return Container(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.join,
        onPressed: join,
        color: ColorRes.white,
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.goBack,
        onPressed: appRouter.goBack,
        color: ColorRes.yellow,
      ),
    );
  }
}
