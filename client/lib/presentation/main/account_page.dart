import 'dart:io';

import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/profile/actions/logout_action.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/features/profile/actions/update_user_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/widgets/friend_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/editable_user_avatar.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/buttons/raised_icon_button.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notification_permissions/notification_permissions.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();
    final dispatch = useDispatcher();
    final friends = useCurrentUserFriends();

    final nativePermissionStatus = usePushNotificationsSettings();
    final tempPermissionValue = useState(true);

    final areNotificationsTurnedOn =
        nativePermissionStatus == PermissionStatus.granted &&
            tempPermissionValue.value;

    final newFullName = useState(user.fullName);
    final newAvatar = useState<File>(null);

    final isInfoTheSame =
        newFullName.value == user.fullName && newAvatar.value == null;

    final updatingState = useGlobalState<OperationState>(
      (s) => s.getOperationState(Operation.updateUser),
    );

    return LoadableView(
      isLoading: updatingState.isInProgress,
      backgroundColor: ColorRes.black.withOpacity(0.2),
      indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const SizedBox(height: 50),
              EditableUserAvatar(
                url: user.avatarUrl,
                onChanged: (file) => newAvatar.value = file,
                size: 200,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: user.fullName,
                style: Styles.accountCommon,
                onChanged: (newValue) => newFullName.value = newValue,
                cursorColor: ColorRes.mainGreen,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: Strings.yourName,
                  labelStyle: const TextStyle(
                    color: ColorRes.mainGreen,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.inviteNotifications,
                    style: Styles.accountCommon,
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
              ),
              const SizedBox(height: 30),
              Text(
                Strings.friends,
                textAlign: TextAlign.start,
                style: Styles.head.copyWith(color: ColorRes.mainBlack),
              ),
              const SizedBox(height: 12),
              ...friends.map((item) => FriendItem(user: item)).toList(),
            ],
          ),
          if (!isInfoTheSame)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: ActionButton(
                color: ColorRes.mainGreen,
                text: Strings.saveChanges,
                onPressed: () {
                  DropFocus.drop();

                  dispatch(
                    UpdateUserAction(
                      userId: user.id,
                      fullName: newFullName.value,
                      avatar: newAvatar.value,
                    ),
                  );

                  newAvatar.value = null;
                },
              ),
            ),
          Positioned(
            top: 50,
            right: 0,
            child: RaisedIconButton(
              onPressed: () => _logout(context),
              icon: Icons.logout,
              iconColor: ColorRes.white,
              buttonColor: ColorRes.red,
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    context
        .dispatch(StopListeningProfileUpdatesAction())
        .then((value) => context.dispatch(LogoutAction()))
        .then((_) => _onLogoutFinished())
        .catchError((_) => _onLogoutFinished());
  }

  void _onLogoutFinished() {
    appRouter.startWith(LoginPage());
  }
}
