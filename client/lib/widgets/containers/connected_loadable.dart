import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class ConnectedLoadable extends StatelessWidget {
  const ConnectedLoadable({
    this.child,
    this.converter,
  });

  final Widget child;
  final bool Function(AppState) converter;

  @override
  Widget build(BuildContext context) {
    return AppStateConnector<bool>(
      converter: converter,
      builder: (context, isLoading) => Loadable(
        isLoading: isLoading,
        child: child,
      ),
    );
  }
}
