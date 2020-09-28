import 'package:cash_flow/presentation/quests/quest_list.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';

class QuestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CashFlowScaffold(
      title: Strings.chooseQuest,
      showUser: true,
      horizontalPadding: 10,
      showBackArrow: true,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: ColorRes.mainGreen,
      child: QuestList(),
    );
  }
}
