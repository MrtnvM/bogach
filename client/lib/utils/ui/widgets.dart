import 'package:flutter/widgets.dart';

Size getWidgetSize(GlobalKey key) {
  final widgetContext = key.currentContext;
  final widgetRenderObject = widgetContext?.findRenderObject() as RenderBox?;
  final widgetSize = widgetRenderObject?.size ?? Size.zero;

  return widgetSize;
}
