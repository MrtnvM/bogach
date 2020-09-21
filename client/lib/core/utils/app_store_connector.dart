import 'package:cash_flow/app/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AppStateConnector<T> extends StatelessWidget {
  const AppStateConnector({
    @required this.converter,
    @required this.builder,
    Key key,
    this.onInit,
    this.distinct = true,
  }) : super(key: key);

  final T Function(AppState) converter;
  final Widget Function(BuildContext, T) builder;
  final void Function(AppState) onInit;
  final bool distinct;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, T>(
      converter: (store) => converter(store.state),
      builder: builder,
      onInit: (store) => onInit?.call(store.state),
      distinct: distinct,
    );
  }
}