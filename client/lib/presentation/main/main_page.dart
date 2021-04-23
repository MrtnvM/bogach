import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/analytics_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/multiplayer/actions/set_online_action.dart';
import 'package:cash_flow/models/domain/user/online/online_profile.dart';
import 'package:cash_flow/presentation/main/account/account_page.dart';
import 'package:cash_flow/presentation/main/games/games_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/advertising/google_ad_native_helper.dart';
import 'package:cash_flow/widgets/common/bogach_loadable_view.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainPage extends HookWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();
    final dispatch = useDispatcher();

    final setOnline = () {
      dispatch(SetUserOnlineAction(
        user: OnlineProfile(
          userId: user.id,
          avatarUrl: user.avatarUrl ?? Images.defaultAvatarUrl,
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

    final isLoadedAd = useState(false);
    final adValue = useState<NativeAd>(null);

    useEffect(() {
      loadAd(isLoadedAd, adValue);
      return null;
    }, []);

    final pageIndex = useState(0);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: BogachLoadableView(
        isLoading: isLoading,
        child: Scaffold(
          backgroundColor: ColorRes.mainPageBackground,
          body: IndexedStack(
            index: pageIndex.value,
            children: [
              GamesPage(),
              if (isLoadedAd.value)
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 72.0,
                        alignment: Alignment.center,
                        child: AdWidget(ad: adValue.value),
                      ),
                      const SizedBox(height: 24),
                      RaisedButton(
                        onPressed: () => loadAd(isLoadedAd, adValue),
                        child: const Text('Load ad'),
                      )
                    ],
                  ),
                )
              else
                AccountPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageIndex.value,
            onTap: (newIndex) {
              pageIndex.value = newIndex;

              const accountPageIndex = 1;
              if (newIndex == accountPageIndex) {
                AnalyticsSender.accountOpen();
              }
            },
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

  void loadAd(
    ValueNotifier<bool> isLoadedAd,
    ValueNotifier<NativeAd> adValue,
  ) async {
    final status = await MobileAds.instance.initialize();
    final s = status.adapterStatuses['GADMobileAds'];
    print(s);

    final nativeAd = NativeAd(
      adUnitId: getNativeGoogleAdUnitId(),
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          isLoadedAd.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
      customOptions: <String, Object>{},
    );

    nativeAd.load();

    adValue.value = nativeAd;
  }
}
