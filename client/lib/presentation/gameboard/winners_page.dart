import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WinnersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final monthNumber = useGlobalState(
      (s) => s.gameState.currentGame.state.monthNumber,
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Strings.winnersPageDescription,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            '$monthNumber ${Strings.months(monthNumber)}',
            style: Styles.caption.copyWith(color: Colors.black, fontSize: 24),
          ),
          const SizedBox(height: 48),
          RaisedButton(
            onPressed: appRouter.goToRoot,
            child: Text(Strings.goToMainMenu),
          ),
        ],
      ),
    );
  }
}
