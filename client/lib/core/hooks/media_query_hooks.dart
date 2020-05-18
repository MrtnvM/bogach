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
