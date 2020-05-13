import 'package:cash_flow/presentation/new_gameboard/tabs/actions_tab.dart';
import 'package:cash_flow/presentation/new_gameboard/tabs/finances_tab.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/bars/bottom_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';

class NewGameBoard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(1);

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
        BottomBarItem(
          title: Strings.historyTabTitle,
          image: Images.historyBarIcon,
          onPressed: () => selectedIndex.value = 2,
        ),
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

    return Scaffold(
      backgroundColor: ColorRes.primaryWhiteColor,
      body: activeTab,
      bottomNavigationBar: BottomBar(
        items: tabItems,
        selectedItemIndex: selectedIndex.value,
      ),
    );
  }
}
