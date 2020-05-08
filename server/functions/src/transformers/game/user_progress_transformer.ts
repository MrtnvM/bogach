import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { UserEntity } from '../../models/domain/user';

export class UserProgressTransformer extends GameTransformer {
  constructor(private eventId: GameEventEntity.Id, private userId: UserEntity.Id) {
    super();
  }

  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    const currentUserProgress = game.currentEvents.findIndex((e) => e.id === this.eventId);
    const isNotLastEvent = currentUserProgress < game.currentEvents.length - 1;
    let newUserProgress: number;

    if (isNotLastEvent) {
      newUserProgress = currentUserProgress + 1;
    } else {
      newUserProgress = isMoveCompleted ? 0 : currentUserProgress;
    }

    return produce(game, (draft) => {
      draft.state.participantProgress[this.userId] = newUserProgress;
    });
  }
}
