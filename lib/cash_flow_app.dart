import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_redux/flutter_redux.dart' as redux;
import 'package:redux/redux.dart';

class CashFlowApp extends StatefulWidget {
  CashFlowApp({
    @required this.store,
    @required this.isAuthorised,
  }) : super(key: GlobalKey<CashFlowAppState>());

  final Store<AppState> store;
  final bool isAuthorised;

  @override
  State<StatefulWidget> createState() => CashFlowAppState();
}

class CashFlowAppState extends State<CashFlowApp> with ReduxComponent {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return redux.StoreProvider(
      store: widget.store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => child,
        navigatorKey: appRouter.navigatorKey,
        home: const HomePage(title: 'Cash Flow'),
      ),
    );
  }

  @override
  void dispose() {
    disposeSubscriptions();
    super.dispose();
  }
}
