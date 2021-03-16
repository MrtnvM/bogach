import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/features/new_game/actions/get_quests_action.dart';
import 'package:cash_flow/presentation/main/games/widgets/profile_bar.dart';
import 'package:cash_flow/presentation/multiplayer/multiplayer_game_list.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/multiplayer_game_count_badge.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/online_profiles_list.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_list.dart';
import 'package:cash_flow/presentation/quests/quest_list.dart';
import 'package:cash_flow/presentation/quests/quests_badge.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GamesPage extends HookWidget {
  const GamesPage();

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final dispatch = useDispatcher();

    final refreshData = () {
      return Future.wait([
        dispatch(GetQuestsAction(userId: userId, isRefreshing: true)),
        dispatch(GetGameTemplatesAction()),
      ]);
    };

    return Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        const ProfileBar(),
        Expanded(
          child: RefreshIndicator(
            color: ColorRes.mainGreen,
            onRefresh: refreshData,
            child: const _GamePageContent(),
          ),
        ),
      ],
    );
  }
}

class _GamePageContent extends HookWidget {
  const _GamePageContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedProfiles = useState(<String>{});
    final size = useAdaptiveSize();

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      children: <Widget>[
        SizedBox(height: size(24)),
        const SectionTitle(text: Strings.singleGame),
        SizedBox(height: size(150), child: TemplateGameList()),
        const Divider(),
        SizedBox(height: size(12)),
        SectionTitle(
          text: Strings.gameLevels,
          actionWidget: QuestsBadge(),
        ),
        SizedBox(height: size(150), child: QuestList()),
        const Divider(),
        SizedBox(height: size(12)),
        SectionTitle(
          text: Strings.multiplayer,
          actionWidget: MultiplayerGameCountBadge(),
        ),
        SizedBox(height: size(12)),
        SizedBox(height: size(60), child: OnlineProfilesList(selectedProfiles)),
        SizedBox(height: size(12)),
        SizedBox(
          height: size(150),
          child: MultiplayerGameList(selectedProfiles),
        ),
        const Divider(),
      ],
    );
  }
}
