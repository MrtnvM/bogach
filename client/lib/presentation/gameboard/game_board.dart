import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/presentation/gameboard/cash_flow_grid.dart';
import 'package:cash_flow/presentation/gameboard/game_event_page.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class GameBoard extends StatefulWidget {
  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> with ReduxState {
  @override
  void initState() {
    super.initState();
    setOrientationLandscape();

    dispatch(
      ListenGameStateStartAction('c8d3e4b6-8f8c-45ae-8bad-f085101a1c0f'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppStateConnector<GameState>(
      converter: (s) => s.gameState,
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(Strings.gameBoardTitle)),
        body: DropFocus(
          child: Loadable(
            isLoading: state.getRequestState.isInProgress,
            child: state.possessions == null ? Container() : _buildBody(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    dispatch(StopListenGameStateAction());
    setOrientationPortrait();

    super.dispose();
  }

  Widget _buildBody() {
    return Row(
      children: const [
        Expanded(child: CashFlowGrid()),
        VerticalDivider(width: 0, thickness: 0),
        Expanded(child: GameEventPage()),
      ],
    );
  }
}
