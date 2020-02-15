import 'dart:async';

import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _authUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Cash Flow game!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  FutureOr<void> _onSigned(AuthResult value) {
    appRouter.goTo(const MainPage());
  }

  void _authUser() {
    _auth.signInAnonymously().then(_onSigned, onError: _onSignInError);
  }

  FutureOr<void> _onSignInError(dynamic error) {
    handleError(
      context: context,
      exception: error,
      onRetry: _authUser,
    );
  }
}
