import 'package:cash_flow/presentation/game_levels/game_levels_list.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';

class GameLevelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CashFlowScaffold(
      title: Strings.chooseLevel,
      showUser: true,
      horizontalPadding: 10,
      child: _buildBody(),
      showBackArrow: true,
    );
  }

  Widget _buildBody() {
    return Container(
      color: ColorRes.mainGreen,
      child: GameLevelList(),
    );
  }
}
