import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/presentation/main/models/selected_item_view_model.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_list.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SingleGamePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      AnalyticsSender.singleplayerPageOpen();
      return null;
    }, []);

    final selectedListsItem = useState(SelectedItemViewModel());

    return CashFlowScaffold(
      title: Strings.chooseQuest,
      horizontalPadding: 0,
      showBackArrow: true,
      child: Container(
        color: ColorRes.mainGreen,
        child: TemplateGameList(selectedListsItem),
      ),
    );
  }
}
