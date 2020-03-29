import 'package:cash_flow/models/network/request_state.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class Loadable extends StatelessWidget {
  const Loadable({
    @required this.child,
    @required this.requestState,
    this.padding,
  });

  final Widget child;
  final RequestState requestState;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        if (requestState.isInProgress)
          Positioned.fill(child: _getLoadingWidget()),
        if (requestState.isFailed) Positioned.fill(child: _getErrorWidget()),
      ],
    );
  }

  Widget _getLoadingWidget() {
    return Container(
      padding: padding,
      color: ColorRes.black64,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _getErrorWidget() {
    return Container(
      alignment: Alignment.center,
      child: const Text('Error'),
    );
  }
}
