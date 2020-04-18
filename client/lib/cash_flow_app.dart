import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
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

class CashFlowAppState extends State<CashFlowApp> with ReduxState {
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
        home: widget.isAuthorised ? const MainPage() : const LoginPage(),
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: ColorRes.scaffoldBackground,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
      ),
    );
  }
}
