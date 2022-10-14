import 'dart:io';

import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/remote_config/remote_config_hooks.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/analytics_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/multiplayer/actions/set_online_action.dart';
import 'package:cash_flow/models/domain/user/online/online_profile.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/account/account_page.dart';
import 'package:cash_flow/presentation/main/games/games_page.dart';
import 'package:cash_flow/presentation/recommendations/recommendations_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/markets.dart';
import 'package:cash_flow/widgets/common/bogach_loadable_view.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'main_page_tab_provider.dart';

var _isOnlineStatusEnabled = true;

class _Tab {
  _Tab({
    required this.tab,
    required this.widget,
    required this.onSelected,
    required this.barItem,
  });

  final MainPageTab tab;
  final Widget widget;
  final VoidCallback onSelected;
  final BottomNavigationBarItem barItem;
}

class MainPage extends HookWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser()!;
    final dispatch = useDispatcher();

    final setOnline = () {
      if (_isOnlineStatusEnabled) {
        dispatch(SetUserOnlineAction(
          user: OnlineProfile(
            userId: user.id,
            avatarUrl: user.avatarUrl ?? Images.defaultAvatarUrl,
            fullName: user.fullName,
          ),
        ));
      }
    };

    useUserIdSender();

    final isLoading = useGlobalState(
      (s) {
        final requests = [
          Operation.createGame,
          Operation.createRoom,
          Operation.createQuestGame,
          Operation.buyWithDiscountAction,
        ];

        return requests
            .map((request) => s.getOperationState(request))
            .any((requestState) => requestState.isInProgress);
      },
    );

    useEffect(setOnline, [user]);

    final stream = useMemoized(
      () => Stream.periodic(const Duration(seconds: 30), (_) => setOnline()),
    );

    useStream(stream, initialData: null);

    final pageIndex = useState(0);

    useAppUpdatesChecker(() {
      AnalyticsSender.updateAppBannerShown();

      showUpdateAppDialog(
        context: context,
        onUpdate: () {
          AnalyticsSender.updateAppBannerButtonClicked();
          launchMarket();
        },
      );
    });

    final tabs = useState([
      _Tab(
        tab: MainPageTab.games,
        widget: const GamesPage(),
        onSelected: () {},
        barItem: BottomNavigationBarItem(
          icon: const Icon(Icons.insights),
          label: Strings.gamesTabTitle,
        ),
      ),
      if (!Platform.isIOS)
        _Tab(
          tab: MainPageTab.recommendations,
          widget: const RecommendationsPage(),
          onSelected: AnalyticsSender.recommendationsOpen,
          barItem: BottomNavigationBarItem(
            icon: const Icon(Icons.thumb_up_off_alt),
            label: Strings.recommendationsTabTitle,
          ),
        ),
      _Tab(
        tab: MainPageTab.account,
        widget: const AccountPage(),
        onSelected: AnalyticsSender.accountOpen,
        barItem: BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: Strings.accountTabTitle,
        ),
      )
    ]);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: BogachLoadableView(
        isLoading: isLoading,
        child: MainPageTabProvider(
          currentTab: tabs.value[pageIndex.value].tab,
          child: Scaffold(
            backgroundColor: ColorRes.mainPageBackground,
            body: IndexedStack(
              index: pageIndex.value,
              children: tabs.value.map((t) => t.widget).toList(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: pageIndex.value,
              onTap: (newIndex) {
                pageIndex.value = newIndex;
                tabs.value[pageIndex.value].onSelected();
              },
              items: tabs.value.map((t) => t.barItem).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
