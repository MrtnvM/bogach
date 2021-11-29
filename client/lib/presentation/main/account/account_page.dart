import 'dart:io';

import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/profile/actions/update_user_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/account/sections/profile_section.dart';
import 'package:cash_flow/presentation/main/account/sections/purchases_section.dart';
import 'package:cash_flow/presentation/main/account/widgets/logout_button.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser()!;
    final dispatch = useDispatcher();

    final newFullName = useState(user.fullName);
    final newAvatar = useState<File?>(null);

    final isInfoTheSame =
        newFullName.value == user.fullName && newAvatar.value == null;

    final isInProgress = useGlobalState((s) {
      final operations = [
        Operation.updateUser,
        Operation.removeFromFriends,
        Operation.restorePurchases
      ];
      return operations.any((o) => s.getOperationState(o).isInProgress);
    })!;

    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();

    final saveUpdatedAccount = () {
      DropFocus.drop();

      VoidCallback? updateProfile;

      updateProfile = () async {
        try {
          final action = UpdateUserAction(
            userId: user.id,
            fullName: newFullName.value,
            avatar: newAvatar.value,
          );

          await dispatch(action);

          if (newAvatar.value != null) {
            AnalyticsSender.accountChangedAvatar();
          }

          if (user.fullName != newFullName.value) {
            AnalyticsSender.accountChangedUsername();
          }

          newAvatar.value = null;
        } catch (error) {
          AnalyticsSender.accountEditingFailed();

          handleError(
            context: context,
            exception: error,
            onRetry: updateProfile,
            errorMessage: Strings.updateProfileErrorMessage,
          );
        }
      };

      updateProfile();
    };

    return LoadableView(
      isLoading: isInProgress,
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
                padding: EdgeInsets.symmetric(vertical: size(16)),
                children: [
                  PurchasesSection(),
                  const Divider(),
                  ProfileSection(
                    onAvatarChanged: (file) => newAvatar.value = file,
                    onUsernameChanged: (name) => newFullName.value = name,
                  )
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
                    onPressed: saveUpdatedAccount,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
