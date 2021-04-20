//
//  ListTileNativeAdFactory.swift
//  Runner
//
//  Created by Robert on 20.04.2021.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

import google_mobile_ads

class ListTileNativeAdFactory : FLTNativeAdFactory {
    
    func createNativeAd(_ nativeAd: GADUnifiedNativeAd,
                        customOptions: [AnyHashable : Any]? = nil) -> GADUnifiedNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("ListTileNativeAdView", owner: nil, options: nil)!.first
        let nativeAdView = nibView as! GADUnifiedNativeAdView
        
        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline
        
        (nativeAdView.bodyView as! UILabel).text = nativeAd.body
        nativeAdView.bodyView!.isHidden = nativeAd.body == nil
        
        (nativeAdView.iconView as! UIImageView).image = nativeAd.icon?.image
        nativeAdView.iconView!.isHidden = nativeAd.icon == nil
        
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        nativeAdView.nativeAd = nativeAd
        
        return nativeAdView
    }
}
