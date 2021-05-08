package io.mobile.bogach.google_ads

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.formats.UnifiedNativeAd
import com.google.android.gms.ads.formats.UnifiedNativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory
import io.mobile.bogach.R

class SingleplayerMonthResultAdFactory(private val context: Context) : NativeAdFactory {

    override fun createNativeAd(
            nativeAd: UnifiedNativeAd,
            customOptions: Map<String, Any>?
    ): UnifiedNativeAdView {
        val layoutInflater = LayoutInflater.from(context)
        val nativeAdView = layoutInflater.inflate(R.layout.singleplayer_month_result_ad, null) as UnifiedNativeAdView

        nativeAdView.setNativeAd(nativeAd)

        val tvTitle = nativeAdView.findViewById<TextView>(R.id.tv_title)
        val tvDescription = nativeAdView.findViewById<TextView>(R.id.tv_description)
        val ivAdImage = nativeAdView.findViewById<ImageView>(R.id.iv_ad_image)
        val tvAdvertiser = nativeAdView.findViewById<TextView>(R.id.tv_advertiser)
        val btnAdAction = nativeAdView.findViewById<Button>(R.id.btn_action)
        val tvStore = nativeAdView.findViewById<TextView>(R.id.tv_store)
        val tvPrice = nativeAdView.findViewById<TextView>(R.id.tv_price)

        tvTitle.text = nativeAd.headline
        nativeAdView.headlineView = tvTitle

        tvDescription.text = nativeAd.body
        nativeAdView.bodyView = tvDescription

        val icon = nativeAd.icon
        ivAdImage.visibility = if (icon != null) View.VISIBLE else View.INVISIBLE
        if (icon != null) {
            ivAdImage.setImageDrawable(nativeAd.icon.drawable)
        }
        nativeAdView.imageView = ivAdImage

        btnAdAction.text = nativeAd.callToAction
        btnAdAction.visibility = if (nativeAd.callToAction != null) View.VISIBLE else View.GONE
        btnAdAction.isClickable = false
        nativeAdView.callToActionView = btnAdAction

        tvStore.text = nativeAd.store
        tvStore.visibility = if (nativeAd.store != null) View.VISIBLE else View.GONE
        nativeAdView.storeView = tvStore

        tvPrice.text = nativeAd.price
        tvPrice.visibility = if (nativeAd.price != null) View.VISIBLE else View.GONE
        nativeAdView.priceView = tvPrice

        tvAdvertiser.text = nativeAd.advertiser
        tvAdvertiser.visibility = if (nativeAd.advertiser != null) View.VISIBLE else View.GONE
        nativeAdView.advertiserView = tvAdvertiser

        return nativeAdView
    }
}