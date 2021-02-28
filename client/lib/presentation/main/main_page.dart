import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/new_game/actions/get_game_templates_action.dart';
import 'package:cash_flow/features/new_game/actions/get_quests_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/widgets/game_type_title.dart';
import 'package:cash_flow/presentation/main/widgets/profile_bar.dart';
import 'package:cash_flow/presentation/multiplayer/multiplayer_game_list.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/multiplayer_game_count_badge.dart';
import 'package:cash_flow/presentation/new_game/widgets/template_game_list.dart';
import 'package:cash_flow/presentation/quests/quest_list.dart';
import 'package:cash_flow/presentation/quests/quests_badge.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/text_button.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();
    final needAuthorization = user == null;
    final dispatch = useDispatcher();

    useEffect(() {
      AnalyticsSender.setUserId(user.userId);
      return null;
    }, [user]);

    final createGameRequestState = useGlobalState<OperationState>(
      (s) => s.getOperationState(Operation.createGame),
    );

    final createRoomRequestState = useGlobalState((s) {
      return s.getOperationState(Operation.createRoom);
    });

    final createQuestGameRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.createQuestGame),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: LoadableView(
        isLoading: createRoomRequestState.isInProgress ||
            createGameRequestState.isInProgress ||
            createQuestGameRequestState.isInProgress,
        backgroundColor: ColorRes.black.withAlpha(120),
        indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
        child: Scaffold(
          backgroundColor: const Color(0xFFfcfcfc),
          body: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).padding.top),
              const ProfileBar(),
              Expanded(
                child: RefreshIndicator(
                  color: ColorRes.mainGreen,
                  onRefresh: () => Future.wait([
                    dispatch(
                      GetQuestsAction(userId: user.id, isRefreshing: true),
                    ),
                    dispatch(GetGameTemplatesAction()),
                  ]),
                  child: _buildGameActions(context),
                ),
              ),
              _buildAuthButton(needAuthorization),
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

  Widget _buildGameActions(BuildContext context) {
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
        SizedBox(height: 150, child: MultiplayerGameList()),
        const Divider(),
      ],
    );
  }

  Widget _buildAuthButton(bool needAuthorization) {
    if (needAuthorization) {
      return TextButton(
        onPressed: _goToLogin,
        text: Strings.doYouWantToLogin,
      );
    }

    return Container();
  }

  void _goToLogin() {
    appRouter.startWith(LoginPage());
  }
}
