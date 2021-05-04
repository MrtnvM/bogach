import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../google_ad_units_ids.dart';

class LoadSingleplayerMonthResultAdAction extends BaseAction {
  LoadSingleplayerMonthResultAdAction({@required this.month});

  final int month;

  @override
  Future<AppState> reduce() async {
    final adUnitId = getNativeGoogleAdUnitId(
      AppConfiguration.environment == CashApiEnvironment.production
          ? AdMobAdUnit.singleplayerMonthResult
          : AdMobAdUnit.test,
    );

    final nativeAd = NativeAd(
      adUnitId: adUnitId,
      factoryId: 'singleplayer_month_result',
      request: const AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          dispatch(SetSinglepalyerMonthResultAd(ad: ad, month: month));
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

class SetSinglepalyerMonthResultAd extends BaseAction {
  SetSinglepalyerMonthResultAd({@required this.ad, @required this.month});

  final Ad ad;
  final int month;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      if (ad != null) {
        s.game.monthResultAds[month] = ad;
      } else {
        s.game.monthResultAds.remove(month);
      }
    });
  }
}
