import 'dart:io';

String getNativeGoogleAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/2247696110'; //'ca-app-pub-3584659164590042/5751202088';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/3986624511'; //'ca-app-pub-3584659164590042/1620385386';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}
