import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_list.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';

class SingleGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CashFlowScaffold(
      title: Strings.chooseLevel,
      showUser: true,
      horizontalPadding: 10,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: ColorRes.mainGreen,
      child: TemplateGameList(),
    );
  }
}
