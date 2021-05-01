import 'dart:io';

enum AdMobAdUnit {
  singleplayerMonthResult,
  test,
}

// TODO this is test ids, need to add release if release build
// https://gitlab.com/cash-flow-team/cash-flow/-/issues/304
// release ids stored in google ad mob account
String getNativeGoogleAdUnitId([AdMobAdUnit adUnit = AdMobAdUnit.test]) {
  assert(adUnit != null);

  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/2247696110';
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
