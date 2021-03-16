import 'dart:io';

import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/profile/actions/update_user_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/presentation/main/widgets/friend_item.dart';
import 'package:cash_flow/presentation/main/widgets/logout_button.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/editable_user_avatar.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Text(
              Strings.accountTabTitle,
              style: Styles.bodyBlackBold.copyWith(
                fontSize: size(16),
              ),
            ),
            actions: const [LogoutButton()],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              ListView(
                padding: EdgeInsets.all(size(16)),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(10),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withAlpha(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EditableUserAvatar(
                          url: user.avatarUrl,
                          onChanged: (file) => newAvatar.value = file,
                          avatarSize: size(150),
                        ),
                        SizedBox(height: size(24)),
                        _NameInput(
                          initialValue: user.fullName,
                          onChange: (name) => newFullName.value = name,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size(32)),
                  _FriendsList(friends: friends),
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
                    withRoundedBorder: true,
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
      ),
    );
  }
}

class _FriendsList extends StatelessWidget {
  const _FriendsList({Key key, @required this.friends}) : super(key: key);

  final List<UserProfile> friends;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    Key key,
    @required this.initialValue,
    @required this.onChange,
  }) : super(key: key);

  final String initialValue;
  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: Styles.bodyBlack,
      onChanged: (value) => onChange(value.trim()),
      cursorColor: ColorRes.mainGreen,
      decoration: InputDecoration(
        isDense: true,
        labelText: Strings.yourName,
        labelStyle: const TextStyle(
          color: ColorRes.mainGreen,
        ),
      ),
    );
  }
}
