//
//  SingleplayerMonthResultAdFactory.swift
//  Runner
//
//  Created by Максим Мартынов on 30.04.2021.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

import UIKit
import google_mobile_ads

class SingleplayerMonthResultAdFactory : FLTNativeAdFactory {
    
    static func register(with registery: FlutterPluginRegistry) {
        let adFactory = SingleplayerMonthResultAdFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            registery,
            factoryId: "singleplayer_month_result",
            nativeAdFactory: adFactory
        )
    }
    
    func createNativeAd(
        _ nativeAd: GADUnifiedNativeAd,
        customOptions: [AnyHashable : Any]? = nil
    ) -> GADUnifiedNativeAdView? {
        
        let nibView = Bundle.main.loadNibNamed(
            "SingleplayerMonthResultAdView",
            owner: nil,
            options: nil
        )!.first
        
        let adView = nibView as! SingleplayerMonthResultAdView
        
        adView.titleLabel.text = nativeAd.headline
        
        adView.descriptionLabel.text = nativeAd.body
        adView.descriptionLabel.isHidden = nativeAd.body == nil
        
        adView.iconImageView.image = nativeAd.icon?.image
        adView.iconImageView.isHidden = nativeAd.icon == nil
        adView.iconImageView.layer.cornerRadius = 8
        adView.iconImageView.layer.masksToBounds = true
        adView.iconImageView.layer.borderWidth = 1
        adView.iconImageView.layer.borderColor =
            UIColor.lightGray.withAlphaComponent(0.25).cgColor
        
        adView.callToActionButton.setTitle(nativeAd.callToAction ?? "", for: .normal)
        adView.callToActionButton.isUserInteractionEnabled = false
        adView.callToActionButton.layer.cornerRadius = 12
        adView.callToActionButton.layer.masksToBounds = true
        
        if (nativeAd.callToAction == nil) {
            adView.callToActionButton.isHidden = true
            adView.callToActionButton.contentEdgeInsets = UIEdgeInsets.zero
        }
        
        adView.ratingImageView.image = imageOfStars(from: nativeAd.starRating)
        adView.ratingImageView.isHidden = nativeAd.starRating == nil
        
        adView.storeLabel.text = nativeAd.store ?? ""
        
        if (nativeAd.store == nil) {
            adView.storeSpacingConstraint.constant = 0
            adView.storeLabel.isHidden = true
        }

        adView.priceLabel.text = nativeAd.price ?? ""
        
        if (nativeAd.price == nil) {
            adView.priceLabel.isHidden = true
            adView.priceSpacingConstraint.constant = 0
        }
        
        adView.advertiserLabel.text = nativeAd.advertiser ?? ""
        adView.advertiserLabel.isHidden = nativeAd.advertiser == nil

        adView.nativeAd = nativeAd
        
        return adView
    }
    
    private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }

        if rating >= 5 {
            return UIImage(named: "stars_5")
        }

        if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        }

        if rating >= 4 {
            return UIImage(named: "stars_4")
        }

        if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        }
        
        return nil
    }
}
