import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game, GameEntity } from '../../models/domain/game/game';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { UserEntity } from '../../models/domain/user';
import { GameTargetEntity } from '../../models/domain/game/game_target';

export class UserProgressTransformer extends GameTransformer {
  constructor(private eventId: GameEventEntity.Id, private userId: UserEntity.Id) {
    super();
  }

  apply(game: Game): Game {
    const currentParticipantEventIndex = game.currentEvents.findIndex((e) => e.id === this.eventId);
    const isNotLastEvent = currentParticipantEventIndex < game.currentEvents.length - 1;
    const currentParticipantProgress = game.state.participantsProgress[this.userId];
    const { monthResults, currentMonthForParticipant } = currentParticipantProgress;

    let newParticipantEventIndex: number;
    let newParticipantProgress: GameEntity.ParticipantProgress;

    if (isNotLastEvent) {
      newParticipantEventIndex = currentParticipantEventIndex + 1;

      newParticipantProgress = {
        currentEventIndex: newParticipantEventIndex,
        currentMonthForParticipant,
        status: 'player_move',
        monthResults,
        progress: GameTargetEntity.calculateProgress(game, this.userId),
      };
    } else {
      newParticipantEventIndex = currentParticipantEventIndex;

      newParticipantProgress = {
        currentEventIndex: newParticipantEventIndex,
        currentMonthForParticipant,
        status: 'month_result',
        monthResults,
        progress: GameTargetEntity.calculateProgress(game, this.userId),
      };
    }

    return produce(game, (draft) => {
      draft.state.participantsProgress[this.userId] = newParticipantProgress;
    });
  }
}
