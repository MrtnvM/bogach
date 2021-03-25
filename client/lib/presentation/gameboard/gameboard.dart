import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/tabs/actions_tab.dart';
import 'package:cash_flow/presentation/gameboard/tabs/finances_tab.dart';
import 'package:cash_flow/presentation/gameboard/tabs/progress_tab.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/bottom_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/current_game_data_provider.dart';
import 'package:cash_flow/presentation/gameboard/winners_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameBoard extends HookWidget {
  const GameBoard({Key key, @required this.gameId}) : super(key: key);

  final String gameId;

  @override
  Widget build(BuildContext context) {
    return CurrentGameDataProvider(
      gameId: gameId,
      child: _GameboardBody(gameId: gameId),
    );
  }
}

class _GameboardBody extends HookWidget {
  const _GameboardBody({@required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(1);
    final activeGameState = useCurrentActiveGameState();
    final gameExists = useCurrentGame((g) => g != null);
    final isMultiplayer = useIsMultiplayerGame();
    final dispatch = useDispatcher();

    /// Stops active game when user exit from current screen
    useEffect(() {
      return () => dispatch(StopGameAction(gameId));
    }, []);

    useGameboardAnalytics();

    final mediaQueryData = useAdaptiveMediaQueryData();

    if (!gameExists) {
      return LoadableView(
        isLoading: !gameExists,
        backgroundColor: ColorRes.white,
        indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
        child: Container(),
      );
    }

    Widget activeTab;

    switch (selectedIndex.value) {
      case 0:
        AnalyticsSender.gameboardFinancesTabOpen();
        activeTab = FinancesTab();
        break;
      case 1:
        activeTab = ActionsTab();
        break;
      case 2:
        AnalyticsSender.gameboardProgressTabOpen();
        activeTab = ProgressTab();
        break;
    }

    final content = activeGameState.maybeMap(
      gameEvent: (_) => activeTab,
      gameOver: (_) => WinnersPage(),
      orElse: () => activeTab,
    );

    return MediaQuery(
      data: mediaQueryData,
      child: Scaffold(
        backgroundColor: ColorRes.primaryWhiteColor,
        body: content,
        bottomNavigationBar: _buildBottomBar(
          context: context,
          isMultiplayer: isMultiplayer,
          activeGameState: activeGameState,
          selectedIndex: selectedIndex,
        ),
      ),
    );
  }

  Widget _buildBottomBar({
    @required BuildContext context,
    @required bool isMultiplayer,
    @required ActiveGameState activeGameState,
    @required ValueNotifier<int> selectedIndex,
  }) {
    return activeGameState.maybeMap(
      gameOver: (_) => null,
      orElse: () {
        var tabs = <BottomBarItem>[];

        final financesTab = BottomBarItem(
          key: GameboardTutorialWidget.of(context)?.financesTabKey,
          title: Strings.financesTabTitle,
          image: Images.financesBarIcon,
          onPressed: () => selectedIndex.value = 0,
        );

        final actionsTab = BottomBarItem(
          title: Strings.actionsTabTitle,
          image: Images.gameBoardBarIcon,
          onPressed: () => selectedIndex.value = 1,
        );

        if (!isMultiplayer) {
          tabs = [financesTab, actionsTab];
        } else {
          final progressTab = BottomBarItem(
            title: Strings.progressTabTitle,
            image: Images.progressBarIcon,
            onPressed: () => selectedIndex.value = 2,
          );

          tabs = [financesTab, actionsTab, progressTab];
        }

        return BottomBar(
          items: tabs,
          selectedItemIndex: selectedIndex.value,
        );
      },
    );
  }
}
