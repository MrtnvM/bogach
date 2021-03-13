import 'package:cash_flow/core/hooks/analytics_hooks.dart';
import 'package:cash_flow/widgets/common/bogach_loadable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/features/new_game/actions/get_quests_action.dart';
import 'package:cash_flow/features/multiplayer/actions/set_online_action.dart';
import 'package:cash_flow/models/domain/user/online/online_profile.dart';
import 'package:cash_flow/presentation/main/widgets/game_type_title.dart';
import 'package:cash_flow/presentation/main/widgets/profile_bar.dart';
import 'package:cash_flow/presentation/multiplayer/multiplayer_game_list.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/multiplayer_game_count_badge.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/online_profiles_list.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_list.dart';
import 'package:cash_flow/presentation/quests/quest_list.dart';
import 'package:cash_flow/presentation/quests/quests_badge.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();
    final userId = user.id;
    final dispatch = useDispatcher();
    final setOnline = () {
      dispatch(SetUserOnlineAction(
        user: OnlineProfile(
          userId: user.id,
          avatarUrl: user.avatarUrl,
          fullName: user.fullName,
        ),
      ));
    };

    useUserIdSender();

    final isLoading = useGlobalState(
      (s) {
        final requests = [
          Operation.createGame,
          Operation.createRoom,
          Operation.createQuestGame
        ];

        return requests
            .map((request) => s.getOperationState(request))
            .any((requestState) => requestState.isInProgress);
      },
    );

    useEffect(() {
      setOnline();
      return null;
    }, [user]);

    final stream = useMemoized(
      () => Stream.periodic(
        const Duration(seconds: 30),
        (_) => setOnline(),
      ),
    );

    useStream(stream, initialData: null);

    final refreshData = () {
      return Future.wait([
        dispatch(GetQuestsAction(userId: userId, isRefreshing: true)),
        dispatch(GetGameTemplatesAction()),
      ]);
    };

    final selectedProfiles = useState(<String>{});

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: BogachLoadableView(
        isLoading: isLoading,
        child: Scaffold(
          backgroundColor: ColorRes.mainPageBackground,
          body: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).padding.top),
              const ProfileBar(),
              Expanded(
                child: RefreshIndicator(
                  color: ColorRes.mainGreen,
                  onRefresh: refreshData,
                  child: _buildGameActions(selectedProfiles),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.insights),
                label: Strings.gamesTabTitle,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: Strings.accountTabTitle,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameActions(ValueNotifier<Set<String>> selectedProfiles) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      children: <Widget>[
        const SizedBox(height: 24),
        const GameTypeTitle(text: Strings.singleGame),
        SizedBox(height: 150, child: TemplateGameList()),
        const Divider(),
        const SizedBox(height: 12),
        GameTypeTitle(
          text: Strings.gameLevels,
          actionWidget: QuestsBadge(),
        ),
        SizedBox(height: 150, child: QuestList()),
        const Divider(),
        const SizedBox(height: 12),
        GameTypeTitle(
          text: Strings.multiplayer,
          actionWidget: MultiplayerGameCountBadge(),
        ),
        const SizedBox(height: 12),
        SizedBox(height: 60, child: OnlineProfilesList(selectedProfiles)),
        const SizedBox(height: 12),
        SizedBox(height: 150, child: MultiplayerGameList(selectedProfiles)),
        const Divider(),
      ],
    );
  }
}
