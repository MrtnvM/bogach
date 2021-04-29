import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class SetGameParticipantsProfilesAction extends BaseAction {
  SetGameParticipantsProfilesAction(this.userProfiles);

  final List<UserProfile> userProfiles;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      s.game.participantProfiles = StoreList<UserProfile>(userProfiles);
    });
  }
}
