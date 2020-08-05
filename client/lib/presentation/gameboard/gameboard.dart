import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/tabs/actions_tab.dart';
import 'package:cash_flow/presentation/gameboard/tabs/finances_tab.dart';
import 'package:cash_flow/presentation/gameboard/winners_page.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/bottom_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';

class GameBoard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(1);
    final activeGameState = useGlobalState((s) => s.game.activeGameState);
    final gameExists = useCurrentGame((g) => g != null);

    final tabItems = useMemoized(
      () => [
        BottomBarItem(
          title: Strings.financesTabTitle,
          image: Images.financesBarIcon,
          onPressed: () => selectedIndex.value = 0,
        ),
        BottomBarItem(
          title: Strings.actionsTabTitle,
          image: Images.gameBoardBarIcon,
          onPressed: () => selectedIndex.value = 1,
        ),
        // BottomBarItem(
        //   title: Strings.historyTabTitle,
        //   image: Images.historyBarIcon,
        //   onPressed: () => selectedIndex.value = 2,
        // ),
      ],
    );

    if (!gameExists) {
      return Loadable(
        isLoading: !gameExists,
        backgroundColor: ColorRes.white,
        indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
        child: Container(),
      );
    }

    Widget activeTab;

    switch (selectedIndex.value) {
      case 0:
        activeTab = FinancesTab();
        break;
      case 1:
        activeTab = ActionsTab();
        break;
      case 2:
        activeTab = FinancesTab();
        break;
    }

    final content = activeGameState.maybeMap(
      gameEvent: (_) => activeTab,
      gameOver: (_) => WinnersPage(),
      orElse: () => activeTab,
    );

    final bottomBar = activeGameState.maybeMap(
      gameOver: (_) => null,
      orElse: () => BottomBar(
        items: tabItems,
        selectedItemIndex: selectedIndex.value,
      ),
    );

    return Scaffold(
      backgroundColor: ColorRes.primaryWhiteColor,
      body: content,
      bottomNavigationBar: bottomBar,
    );
  }
}
