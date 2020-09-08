import 'package:cash_flow/navigation/app_router.dart';
import 'package:flutter/material.dart';

class FullscreenPopupContainer extends StatelessWidget {
  const FullscreenPopupContainer({
    Key key,
    @required this.backgroundColor,
    @required this.content,
    this.onClose,
  }) : super(key: key);

  final Color backgroundColor;
  final Widget content;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: backgroundColor,
            body: Container(
              width: double.infinity,
              child: content,
            ),
          ),
          GestureDetector(
            onTap: onClose ?? appRouter.goBack,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.only(top: topPadding),
              child: Icon(
                Icons.clear,
                color: Colors.white.withAlpha(150),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
