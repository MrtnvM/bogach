// TODO: Import ListTileNativeAdFactory.h
#import "ListTileNativeAdFactory.h"

// TODO: Implement ListTileNativeAdFactory
@implementation ListTileNativeAdFactory

- (GADUnifiedNativeAdView *)createNativeAd:(GADUnifiedNativeAd *)nativeAd
                             customOptions:(NSDictionary *)customOptions {
  GADUnifiedNativeAdView *nativeAdView =
    [[NSBundle mainBundle] loadNibNamed:@"ListTileNativeAdView" owner:nil options:nil].firstObject;

  nativeAdView.nativeAd = nativeAd;

  ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;

  ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
  nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;

  ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
  nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

  nativeAdView.callToActionView.userInteractionEnabled = NO;

  return nativeAdView;
}

@end