import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class Loadable extends StatelessWidget {
  const Loadable({
    @required this.child,
    @required this.loading,
    this.padding,
  });

  final Widget child;
  final bool loading;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        Positioned.fill(child: _getLoadingWidget()),
      ],
    );
  }

  Widget _getLoadingWidget() {
    return Visibility(
      visible: loading,
      child: Container(
        padding: padding,
        color: ColorRes.black64,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
