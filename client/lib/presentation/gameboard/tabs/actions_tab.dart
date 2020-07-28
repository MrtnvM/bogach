import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/presentation/gameboard/game_event_page.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/progress_bar.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:cash_flow/widgets/containers/container_with_header_image.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ActionsTab extends HookWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final target = useCurrentGame((g) => g.target);
    final currentMonth = useCurrentGame((g) => g.state.monthNumber);
    final monthLimit = useCurrentGame((g) => g.config?.monthLimit);

    final monthPast = monthLimit != null
        ? '${Strings.monthsPast}: ${currentMonth - 1} / $monthLimit'
        : null;

    final targetTitle = monthPast ?? mapTargetTypeToString(target.type);
    final user = useGlobalState((s) => s.login.currentUser);

    return ContainerWithHeaderImage(
      navBarTitle: user.fullName,
      subTitle: targetTitle,
      imageUrl: user.avatarUrl,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CardContainer(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: const <Widget>[
                    ProgressBar(),
                    SizedBox(height: 16),
                    AccountBar(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const GameEventPage(),
            ],
          ),
        ),
      ],
    );
  }
}
