package io.mobile.bogach

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.mobile.bogach.goggle_ad.ListTileNativeAdFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTile",
             ListTileNativeAdFactory(context));
    }
}
