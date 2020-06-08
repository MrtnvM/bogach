import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/presentation/gameboard/tabs/actions_tab.dart';
import 'package:cash_flow/presentation/gameboard/tabs/finances_tab.dart';
import 'package:cash_flow/presentation/gameboard/winners_page.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/bottom_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';

class GameBoard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(1);
    final activeGameState = useGlobalState((s) => s.game.activeGameState);

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

    return Scaffold(
      backgroundColor: ColorRes.primaryWhiteColor,
      body: content,
      bottomNavigationBar: BottomBar(
        items: tabItems,
        selectedItemIndex: selectedIndex.value,
      ),
    );
  }
}
