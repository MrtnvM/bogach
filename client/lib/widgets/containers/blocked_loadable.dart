import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class BlockedLoadable extends StatelessWidget {
  const BlockedLoadable({
    @required this.child,
    @required this.loading,
    this.indicatorColor = Colors.white,
  });

  final Widget child;
  final bool loading;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: Visibility(
            visible: loading,
            child: Container(
              color: ColorRes.black64,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
