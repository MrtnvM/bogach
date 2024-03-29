import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

MediaQueryData useMediaQuery() {
  final context = useContext();
  final mediaQuery = MediaQuery.of(context);
  return mediaQuery;
}

EdgeInsets useNotchSize() {
  final mediaQuery = useMediaQuery();
  final notchSize = mediaQuery.padding;
  return notchSize;
}

Size useScreenSize() {
  final mediaQuery = useMediaQuery();
  final screenSize = mediaQuery.size;
  return screenSize;
}

MediaQueryData useAdaptiveMediaQueryData() {
  final mediaQuery = useMediaQuery();
  final scaleFactor = useScaleFactor();

  return mediaQuery.copyWith(
    textScaleFactor: scaleFactor,
  );
}

double Function(double) useAdaptiveSize() {
  final scaleFactor = useScaleFactor();
  return (size) => size * scaleFactor;
}

double useScaleFactor() {
  final mediaQuery = useMediaQuery();
  final screenWidth = mediaQuery.size.width;

  const designDeviceScreenSize = 375.0;
  final scaleFactor = min(screenWidth / designDeviceScreenSize, 1.0);

  return scaleFactor;
}
