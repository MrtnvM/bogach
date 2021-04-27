import 'dart:io';

// TODO this is test ids, need to add release if release build
// https://gitlab.com/cash-flow-team/cash-flow/-/issues/304
// release ids stored in google ad mob account
String getNativeGoogleAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/2247696110';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/3986624511';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}
