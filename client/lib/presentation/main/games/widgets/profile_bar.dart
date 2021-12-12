import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/presentation/main/games/widgets/online_status.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfileBar extends HookWidget {
  const ProfileBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();
    final onlineStatus = useOnlineStatus();
    final user = useCurrentUser()!.copyWith(
      status: onlineStatus.description,
    );

    final barWidget = MediaQuery(
      data: mediaQuery,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size(16),
          horizontal: size(22),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.withAlpha(100),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAvatar(
              url: user.avatarUrl,
              size: size(60),
              borderWidth: size(2.5),
              borderColor: onlineStatus.color,
            ),
            SizedBox(width: size(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.fullName}',
                    style: Styles.body1.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: size(16),
                    ),
                  ),
                  if (user.status != null)
                    Text(
                      '${user.status}',
                      style: Styles.body1.copyWith(
                        color: Colors.black.withAlpha(170),
                        fontWeight: FontWeight.normal,
                        fontSize: size(13),
                      ),
                    ),
                ],
              ),
            ),
            const OnlineStatus(),
          ],
        ),
      ),
    );

    // return ControlPanelGate(
    //   isEnabled: AppConfiguration.controlPanelEnabled,
    //   child: barWidget,
    // );

    return barWidget;
  }
}
