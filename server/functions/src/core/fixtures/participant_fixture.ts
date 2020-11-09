import { Account } from '../../models/domain/account';
import { GameEntity } from '../../models/domain/game/game';
import { PossessionsEntity } from '../../models/domain/possessions';
import { PossessionStateEntity } from '../../models/domain/possession_state';
import { UserEntity } from '../../models/domain/user/user';

export namespace ParticipantFixture {
  export const createParticipant = (
    participant: Partial<GameEntity.Participant> | undefined = undefined
  ): GameEntity.Participant => {
    const id: UserEntity.Id = participant?.id ?? 'user1';
    const account: Account = participant?.account ?? {
      cashFlow: 10_000,
      cash: 20_000,
      credit: 0,
    };

    const possessions = participant?.possessions ?? PossessionsEntity.createEmpty();
    const possessionState = participant?.possessionState ?? PossessionStateEntity.createEmpty();

    // TODO: Calculate possession state before calculation of progress
    const progress =
      participant?.progress ?? GameEntity.initialParticipantProgress(possessionState, account);

    return {
      id,
      account,
      possessions,
      possessionState,
      progress,
    };
  };
}
