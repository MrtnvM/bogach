import 'dart:io';

import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/core/hooks/push_notification_hooks.dart';
import 'package:cash_flow/features/profile/actions/logout_action.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/features/profile/actions/update_user_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
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

    final newFullName = useState(user.fullName);
    final newAvatar = useState<File>(null);

    final isInfoTheSame =
        newFullName.value == user.fullName && newAvatar.value == null;

    final updatingState = useGlobalState<OperationState>(
      (s) => s.getOperationState(Operation.updateUser),
    );

    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();

    return LoadableView(
      isLoading: updatingState.isInProgress,
      backgroundColor: ColorRes.black.withOpacity(0.2),
      indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
      child: MediaQuery(
        data: mediaQuery,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListView(
              padding: EdgeInsets.all(size(24)),
              children: [
                SizedBox(
                  height: size(200),
                  width: double.infinity,
                  child: Stack(
                    children: [
                      _buildAvatarWidget(
                        user: user,
                        newAvatar: newAvatar,
                        avatarSize: size(150),
                      ),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
                SizedBox(height: size(24)),
                TextFormField(
                  initialValue: user.fullName,
                  style: Styles.bodyBlack,
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
                SizedBox(height: size(32)),
                Text(
                  Strings.friends,
                  textAlign: TextAlign.start,
                  style: Styles.head.copyWith(color: ColorRes.mainBlack),
                ),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),
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
                    newAvatar.value = null;

                    dispatch(
                      UpdateUserAction(
                        userId: user.id,
                        fullName: newFullName.value,
                        avatar: newAvatar.value,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Positioned _buildAvatarWidget({
    @required UserProfile user,
    @required ValueNotifier<File> newAvatar,
    @required double avatarSize,
  }) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: EditableUserAvatar(
        url: user.avatarUrl,
        onChanged: (file) => newAvatar.value = file,
        avatarSize: avatarSize,
      ),
    );
  }

  Positioned _buildLogoutButton(BuildContext context) {
    return Positioned(
      top: 12,
      right: 0,
      child: RaisedIconButton(
        onPressed: () => _logout(context),
        icon: Icons.logout,
        iconColor: ColorRes.red,
        buttonColor: ColorRes.transparent,
        size: 24,
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Strings.sureToGoOut,
            style: Styles.bodyBlackBold,
          ),
          actions: [
            FlatButton(
              onPressed: appRouter.goBack,
              child: const Text(Strings.cancel),
            ),
            FlatButton(
              onPressed: () {
                context
                    .dispatch(StopListeningProfileUpdatesAction())
                    .then((value) => context.dispatch(LogoutAction()))
                    .then((_) => _onLogoutFinished())
                    .catchError((_) => _onLogoutFinished());
              },
              child: Text(
                Strings.goOut,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onLogoutFinished() {
    appRouter.startWith(LoginPage());
  }
}

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
