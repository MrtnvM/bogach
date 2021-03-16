import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notification_permissions/notification_permissions.dart';

class NotificationsSettingsWidget extends HookWidget {
  const NotificationsSettingsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nativePermissionStatus = usePushNotificationsSettings();
    final tempPermissionValue = useState(true);

    final areNotificationsTurnedOn =
        nativePermissionStatus == PermissionStatus.granted &&
            tempPermissionValue.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            Strings.inviteNotifications,
            style: Styles.bodyBlack.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        Checkbox(
          checkColor: ColorRes.mainBlack,
          activeColor: ColorRes.mainGreen,
          value: areNotificationsTurnedOn,
          onChanged: (newValue) {
            tempPermissionValue.value = newValue;
          },
        ),
      ],
    );
  }
}
