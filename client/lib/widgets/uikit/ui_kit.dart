import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiKit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DropFocus(
        child: ListView(
          children: <Widget>[
            _getTables(),
            _getGroupDivider(),
          ],
        ),
      ),
    );
  }

  Widget _getGroupDivider() {
    return const Divider(height: 32);
  }

  Widget _getTables() {
    return Container();
  }
}
