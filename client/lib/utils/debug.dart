import 'package:flutter/foundation.dart';

mixin Debug {
  static bool isDebugModeEnabled() {
    return !kReleaseMode;
  }

  static bool isDemoMode = true;
}

void debug(void Function() debugAction) {
  if (Debug.isDebugModeEnabled()) {
    debugAction();
  }
}

void release(void Function() releaseAction) {
  if (!Debug.isDebugModeEnabled()) {
    releaseAction();
  }
}

void demo(void Function() demoAction) {
  if (Debug.isDemoMode) {
    demoAction();
  }
}
