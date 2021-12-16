import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/cupertino.dart';

class ConnectedLoadable extends StatelessWidget {
  const ConnectedLoadable({
    this.child,
    this.converter,
  });

  final Widget? child;
  final bool Function(AppState)? converter;

  @override
  Widget build(BuildContext context) {
    return AppStateConnector<bool>(
      converter: converter,
      builder: (context, isLoading) => LoadableView(
        isLoading: isLoading,
        child: child!,
      ),
    );
  }
}
