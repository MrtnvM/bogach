import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:fimber/fimber.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../google_ad_native_helper.dart';

// TODO decide where to call https://gitlab.com/cash-flow-team/cash-flow/-/issues/304
class LoadNativeAdAction extends BaseAction {
  LoadNativeAdAction();

  @override
  Future<AppState> reduce() async {
    final nativeAd = NativeAd(
      adUnitId: getNativeGoogleAdUnitId(),
      // TODO change factory id https://gitlab.com/cash-flow-team/cash-flow/-/issues/304
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          // TODO remove log https://gitlab.com/cash-flow-team/cash-flow/-/issues/304
          print("ad loaded");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();

          final errorMessage =
              'Ad load failed (code=${error.code} message=${error.message})';
          Fimber.e(errorMessage, ex: error);
        },
      ),
      // should pass for iOS to avoid crash
      customOptions: <String, Object>{},
    );

    nativeAd.load();

    // TODO put native ad in state https://gitlab.com/cash-flow-team/cash-flow/-/issues/304
    return state;
  }
}
