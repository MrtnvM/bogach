import 'dart:io';

enum AdMobAdUnit {
  singleplayerMonthResult,
  test,
}

String getNativeGoogleAdUnitId([AdMobAdUnit adUnit = AdMobAdUnit.test]) {
  assert(adUnit != null);

  if (Platform.isAndroid) {
    switch (adUnit) {
      case AdMobAdUnit.singleplayerMonthResult:
        return 'ca-app-pub-3584659164590042/4050740041';

      case AdMobAdUnit.test:
        return 'ca-app-pub-3940256099942544/2247696110';

      default:
        throw UnsupportedError('Unsupported iOS ad unit');
    }
  }

  if (Platform.isIOS) {
    switch (adUnit) {
      case AdMobAdUnit.singleplayerMonthResult:
        return 'ca-app-pub-3584659164590042/1620385386';

      case AdMobAdUnit.test:
        return 'ca-app-pub-3940256099942544/3986624511';

      default:
        throw UnsupportedError('Unsupported iOS ad unit');
    }
  }

  throw UnsupportedError('Unsupported platform');
}
