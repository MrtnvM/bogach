import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'load_singleplayer_month_result_ad_action.dart';

void useSingleplayerMonthResultAdLoader() {
  final dispatch = useDispatcher();
  final month = useCurrentGame((g) => g?.state.monthNumber);
  final isSingleplayerGame = useIsSingleplayerGame();

  _useAdDisposer();

  useEffect(() {
    /// We should load the ad ahead of showing
    final monthForAd = month != null ? month + 3 : null;

    /// We show ad not for every month, only once in 3 month
    final isAppropriateMonth = monthForAd != null && (monthForAd - 1) % 3 == 0;
    final shouldLoadAd = isAppropriateMonth && isSingleplayerGame;

    if (shouldLoadAd) {
      dispatch(LoadSingleplayerMonthResultAdAction(month: monthForAd));
    }

    return null;
  }, [month]);
}

void _useAdDisposer() {
  final dispatch = useDispatcher();
  final month = useCurrentGame((g) => g?.state.monthNumber);
  final isSingleplayerGame = useIsSingleplayerGame();
  final ads = useGlobalState((s) => s.game.monthResultAds);

  if (month == null || !isSingleplayerGame) {
    return;
  }

  final adsForDispose = ads?.entries //
      .where((e) => e.key < month)
      .toList() ?? [];

  for (final adEntry in adsForDispose) {
    final month = adEntry.key;
    final ad = adEntry.value;

    ad.dispose();
    dispatch(SetSinglepalyerMonthResultAd(month: month, ad: null));
  }
}
