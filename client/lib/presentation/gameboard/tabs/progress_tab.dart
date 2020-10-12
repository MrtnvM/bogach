import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/presentation/gameboard/widgets/chart/dot/dot_user_progress_chart.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/container_with_header_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProgressTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final game = useGlobalState((s) => s.game.currentGame);

    return ContainerWithHeaderImage(
      navBarTitle: Strings.progressTabTitle,
      imageSvg: Images.financesBarIcon,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 60, left: 32, right: 32),
          height: 400,
          child: DotUserProgressChart(game: game),
        )
      ],
    );
  }
}
