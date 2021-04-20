package io.mobile.bogach.goggle_ad

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.formats.UnifiedNativeAd
import com.google.android.gms.ads.formats.UnifiedNativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory
import io.mobile.bogach.R

class ListTileNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: UnifiedNativeAd, customOptions: Map<String, Any>?): UnifiedNativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_banner, null) as UnifiedNativeAdView
        nativeAdView.setNativeAd(nativeAd)
        val attributionViewSmall = nativeAdView
            .findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_small)
        val attributionViewLarge = nativeAdView
            .findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_large)
        val iconView = nativeAdView.findViewById<ImageView>(R.id.iv_list_tile_native_ad_icon)
        val icon = nativeAd.icon
        if (icon != null) {
            attributionViewSmall.visibility = View.VISIBLE
            attributionViewLarge.visibility = View.INVISIBLE
            iconView.setImageDrawable(icon.drawable)
        } else {
            attributionViewSmall.visibility = View.INVISIBLE
            attributionViewLarge.visibility = View.VISIBLE
        }
        nativeAdView.iconView = iconView
        val headlineView = nativeAdView.findViewById<TextView>(R.id.tv_list_tile_native_ad_headline)
        headlineView.text = nativeAd.headline
        nativeAdView.headlineView = headlineView
        val bodyView = nativeAdView.findViewById<TextView>(R.id.tv_list_tile_native_ad_body)
        bodyView.text = nativeAd.body
        bodyView.visibility = if (nativeAd.body != null) View.VISIBLE else View.INVISIBLE
        nativeAdView.bodyView = bodyView
        return nativeAdView
    }

}