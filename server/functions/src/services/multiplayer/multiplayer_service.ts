import { UserProvider } from '../../providers/user_provider';
import { UserEntity } from '../../models/domain/user/user';
import { ErrorRecorder } from '../../config';
import { OnlineProfile, OnlineProfileEntity } from '../../models/domain/multiplayer/online_profile';
import { nowInUtc } from '../../utils/datetime';

export class MultiplayerService {
  constructor(private userProvider: UserProvider) {}

  private errorRecorder = new ErrorRecorder('Multiplayer Service');

  async setOnlineStatus(userId: UserEntity.Id, fullName: string, avatarUrl: string): Promise<void> {
    const context = { userId, fullName, avatarUrl, function: 'setOnlineStatus' };
    return this.errorRecorder.executeWithErrorRecording(context, async () => {
      if (!userId || !fullName || !avatarUrl) {
        throw new Error('User info has incorrect format');
      }

      const onlineAt = nowInUtc();
      const onlineProfile = { userId, fullName, avatarUrl, onlineAt };

      OnlineProfileEntity.validate(onlineProfile);

      await this.userProvider.setOnlineStatus(onlineProfile);
    });
  }

  async getOnlineProfiles(userId: UserEntity.Id): Promise<OnlineProfile[]> {
    const context = { userId, function: 'setOnlineStatus' };
    return this.errorRecorder.executeWithErrorRecording(context, async () => {
      const onlineProfiles = await this.userProvider.getOnlineProfiles(userId);

      return onlineProfiles;
    });
  }
}
