import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/presentation/quests/quest_list.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _isQuestsPageWasAlreadyOpenKey = 'is_quests_page_was_already_open';

class QuestsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      SharedPreferences.getInstance().then((prefs) {
        final isQuestsPageWasAlreadyOpen =
            prefs.getBool(_isQuestsPageWasAlreadyOpenKey) ?? false;

        if (!isQuestsPageWasAlreadyOpen) {
          prefs.setBool(_isQuestsPageWasAlreadyOpenKey, true);
          AnalyticsSender.questsFirstOpen();
        }
      });

      AnalyticsSender.questsPageOpen();
      return null;
    }, []);

    return CashFlowScaffold(
      title: Strings.chooseQuest,
      showUser: true,
      horizontalPadding: 0,
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
