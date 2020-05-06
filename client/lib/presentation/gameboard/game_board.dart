import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/presentation/gameboard/cash_flow_grid.dart';
import 'package:cash_flow/presentation/gameboard/game_event_page.dart';
import 'package:cash_flow/presentation/gameboard/winners_page.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key key, @required this.gameContext})
      : assert(gameContext != null),
        super(key: key);

  final GameContext gameContext;

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> with ReduxState {
  @override
  void initState() {
    super.initState();

    setOrientationLandscape();
    dispatch(SetGameContextAction(widget.gameContext));
    dispatch(StartGameAction(widget.gameContext));
  }

  @override
  Widget build(BuildContext context) {
    return AppStateConnector<GameState>(
      converter: (s) => s.gameState,
      builder: (context, state) => Scaffold(
        appBar: CashAppBar.withBackButton(title: Strings.gameBoardTitle),
        body: DropFocus(
          child: Loadable(
            isLoading: state.getRequestState.isInProgress,
            child: _buildContent(state),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    setOrientationPortrait();
    dispatch(StopActiveGameAction());

    super.dispose();
  }

  Widget _buildContent(GameState s) {
    if (s.possessions == null) {
      return Container();
    }

    return s.activeGameState.maybeMap(
      gameEvent: (_) => _buildGameBoard(),
      gameOver: (_) => WinnersPage(),
      orElse: () => Container(),
    );
  }

  Widget _buildGameBoard() {
    return Row(
      children: const [
        Expanded(child: CashFlowGrid()),
        VerticalDivider(width: 0, thickness: 0),
        Expanded(child: GameEventPage()),
      ],
    );
  }
}
