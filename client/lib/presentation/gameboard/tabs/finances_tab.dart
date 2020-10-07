import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/presentation/gameboard/possessions/assets_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/expenses_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/incomes_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/liabilities_list.dart';
import 'package:cash_flow/presentation/gameboard/widgets/chart/dot/dot_user_progress_chart.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/container_with_header_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FinancesTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final game = useGlobalState((s) => s.game.currentGame);

    return ContainerWithHeaderImage(
      navBarTitle: Strings.financesTabTitle,
      imageSvg: Images.financesBarIcon,
      children: [
        Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          child: DotUserProgressChart(game: game),
        ),
        _buildList(IncomesList(), isFirst: true),
        _buildList(ExpensesList()),
        _buildList(AssetsList()),
        _buildList(LiabilitiesList()),
      ],
    );
  }

  Widget _buildList(Widget listWidget, {bool isFirst = false}) {
    return Container(
      padding: EdgeInsets.only(top: isFirst ? 0 : 16, left: 16, right: 16),
      child: listWidget,
    );
  }
}
