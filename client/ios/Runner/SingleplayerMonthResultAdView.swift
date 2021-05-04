//
//  SingleplayerMonthResultAdView.swift
//  Runner
//
//  Created by Максим Мартынов on 30.04.2021.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

import UIKit
import google_mobile_ads

class SingleplayerMonthResultAdView : GADUnifiedNativeAdView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var storeSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var advertiserLabel: UILabel!
}
