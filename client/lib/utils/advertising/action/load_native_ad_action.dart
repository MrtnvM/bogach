import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:fimber/fimber.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../google_ad_native_helper.dart';

class LoadSingleplayerMonthResultAdAction extends BaseAction {
  LoadSingleplayerMonthResultAdAction();

  @override
  Future<AppState> reduce() async {
    final nativeAd = NativeAd(
      adUnitId: getNativeGoogleAdUnitId(),
      factoryId: 'singleplayer_month_result',
      request: const AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          dispatch(SetSinglepalyerMonthResultAd(ad));
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

    return null;
  }
}
}
