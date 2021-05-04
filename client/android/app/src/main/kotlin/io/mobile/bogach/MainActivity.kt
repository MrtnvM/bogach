package io.mobile.bogach

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.mobile.bogach.google_ads.GoogleAdConstants
import io.mobile.bogach.google_ads.SingleplayerMonthResultAdFactory

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine,
                GoogleAdConstants.singleplayerMonthResultAd,
                SingleplayerMonthResultAdFactory(context)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(
                flutterEngine, GoogleAdConstants.singleplayerMonthResultAd
        )
    }
}
