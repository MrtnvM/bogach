package io.mobile.bogach

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.mobile.bogach.goggle_ad.GoogleAdConstants
import io.mobile.bogach.goggle_ad.ListTileNativeAdFactory

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        //TODO change factoryId https://gitlab.com/cash-flow-team/cash-flow/-/issues/304
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            GoogleAdConstants.factoryId,
            ListTileNativeAdFactory(context)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, GoogleAdConstants.factoryId)
    }
}
