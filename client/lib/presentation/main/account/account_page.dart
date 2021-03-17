import 'dart:io';

import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/profile/actions/update_user_action.dart';
import 'package:cash_flow/presentation/main/account/widgets/friends_list_widget.dart';
import 'package:cash_flow/presentation/main/account/widgets/logout_button.dart';
import 'package:cash_flow/presentation/main/account/widgets/name_input.dart';
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
              style: Styles.bodyBlackBold.copyWith(fontSize: 16),
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
                        color: ColorRes.lightGrey,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EditableUserAvatar(
                          url: user.avatarUrl,
                          onChanged: (file) => newAvatar.value = file,
                          avatarSize: size(size(150)),
                        ),
                        SizedBox(height: size(24)),
                        NameInput(
                          initialValue: user.fullName,
                          onChange: (name) => newFullName.value = name,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size(32)),
                  FriendsListWidget(friends: friends),
                ],
              ),
              if (!isInfoTheSame)
                Positioned(
                  bottom: 4,
                  left: 24,
                  right: 24,
                  child: ActionButton(
                    color: ColorRes.mainGreen,
                    text: Strings.saveChanges,
                    withRoundedBorder: true,
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
            ],
          ),
        ),
      ),
    );
  }
}
