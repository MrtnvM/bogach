import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/tabs/actions_tab.dart';
import 'package:cash_flow/presentation/gameboard/tabs/finances_tab.dart';
import 'package:cash_flow/presentation/gameboard/tabs/progress_tab.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/bottom_tab_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/top_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/current_game_data_provider.dart';
import 'package:cash_flow/presentation/gameboard/widgets/menu/gameboard_menu.dart';
import 'package:cash_flow/presentation/gameboard/widgets/menu/gameboard_menu_controller.dart';
import 'package:cash_flow/presentation/gameboard/winners_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameboardTabItem {
  const GameboardTabItem({@required this.tab, @required this.widget});

  final Widget widget;
  final BottomTabBarItem tab;
}

class GameBoard extends HookWidget {
  const GameBoard({Key key, @required this.gameId}) : super(key: key);

  final String gameId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CurrentGameDataProvider(
        gameId: gameId,
        child: _GameboardBody(gameId: gameId),
      ),
    );
  }
}

class _GameboardBody extends HookWidget {
  const _GameboardBody({@required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = useAdaptiveMediaQueryData();

    final activeGameState = useCurrentActiveGameState();
    final gameExists = useCurrentGame((g) => g != null);
    final isMultiplayer = useIsMultiplayerGame();

    useGameboardAnalytics();
    useGameWatcher();

    if (!gameExists) {
      return const _LoadingGameWidget();
    }

    final tabItems = _getTabItems(context, isMultiplayer);

    return MediaQuery(
      data: mediaQueryData,
      child: Scaffold(
        backgroundColor: ColorRes.primaryWhiteColor,
        body: DefaultTabController(
          length: tabItems.length,
          initialIndex: 1,
          child: activeGameState.maybeMap(
            gameEvent: (_) => _GameboardContentWidget(tabItems: tabItems),
            gameOver: (_) => WinnersPage(),
            orElse: () => _GameboardContentWidget(tabItems: tabItems),
          ),
        ),
      ),
    );
  }

  List<GameboardTabItem> _getTabItems(
    BuildContext context,
    bool isMultiplayer,
  ) {
    final financesTabItem = GameboardTabItem(
      tab: BottomTabBarItem(
        key: GameboardTutorialWidget.of(context)?.financesTabKey,
        title: Strings.financesTabTitle,
        svgAsset: Images.financesBarIcon,
      ),
      widget: FinancesTab(),
    );

    final actionsTabItem = GameboardTabItem(
      tab: BottomTabBarItem(
        title: Strings.actionsTabTitle,
        svgAsset: Images.gameBoardBarIcon,
      ),
      widget: ActionsTab(),
    );

    if (!isMultiplayer) {
      return [financesTabItem, actionsTabItem];
    }

    final progressTabItem = GameboardTabItem(
      tab: BottomTabBarItem(
        title: Strings.progressTabTitle,
        svgAsset: Images.progressBarIcon,
      ),
      widget: ProgressTab(),
    );

    return [financesTabItem, actionsTabItem, progressTabItem];
  }
}

class _GameboardContentWidget extends HookWidget {
  const _GameboardContentWidget({@required this.tabItems});

  final List<GameboardTabItem> tabItems;

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    final tabs = tabItems.map((i) => i.tab).toList();
    final tabWidgets = tabItems.map((i) => i.widget).toList();
    final menuController = useState(GameboardMenuController());

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          Positioned.fill(
            top: TopBar.height - TopBar.bottomOffset,
            child: Column(
              children: [
                Expanded(child: TabBarView(children: tabWidgets)),
                BottomTabBar(
                  tabController: tabController,
                  activeColor: ColorRes.mainGreen,
                  items: tabs,
                  onTap: (i) => DefaultTabController.of(context).animateTo(i),
                ),
              ],
            ),
          ),
          TopBar(
            onMenuTap: () {
              if (menuController.value.isShown) {
                menuController.value.close();
              } else {
                menuController.value.show();
              }
            },
          ),
          GameboardMenu(controller: menuController.value),
        ],
      ),
    );
  }
}

class _LoadingGameWidget extends HookWidget {
  const _LoadingGameWidget();

  @override
  Widget build(BuildContext context) {
    final gameExists = useCurrentGame((g) => g != null);
    final notchSize = useNotchSize();

    return Stack(
      children: [
        Center(
          child: LoadableView(
            isLoading: !gameExists,
            backgroundColor: ColorRes.white,
            indicatorColor: const AlwaysStoppedAnimation(ColorRes.mainGreen),
            child: Container(),
          ),
        ),
        GestureDetector(
          onTap: appRouter.goBack,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: notchSize.top + 16,
              horizontal: 16,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
