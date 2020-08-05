import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';

class ConnectedBlockedLoadable extends StatelessWidget {
  const ConnectedBlockedLoadable({
    @required this.child,
    @required this.converter,
    this.indicatorColor = Colors.white,
  });

  final Widget child;
  final Color indicatorColor;
  final bool Function(AppState) converter;

  @override
  Widget build(BuildContext context) {
    return AppStateConnector<bool>(
      converter: converter,
      builder: (context, isLoading) => BlockedLoadable(
        isLoading: isLoading,
        child: child,
      ),
    );
  }
}
