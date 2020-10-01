import produce from 'immer';

import { GameTransformer } from './game_transformer';
import { Game, GameEntity } from '../../models/domain/game/game';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { UserEntity } from '../../models/domain/user';
import { GameTargetEntity } from '../../models/domain/game/game_target';

export class UserProgressTransformer extends GameTransformer {
  constructor(
    private eventId: GameEventEntity.Id | undefined,
    private userId: UserEntity.Id,
    private completeMonth: boolean = false
  ) {
    super();
  }

  apply(game: Game): Game {
    const currentEventIndex = this.completeMonth
      ? game.currentEvents.length - 1
      : game.currentEvents.findIndex((e) => e.id === this.eventId);

    const currentParticipantProgress = game.state.participantsProgress[this.userId];
    const { monthResults, currentMonthForParticipant } = currentParticipantProgress;

    const shouldCompleteMonth =
      this.completeMonth || currentEventIndex >= game.currentEvents.length - 1;

    const newEventIndex = shouldCompleteMonth ? currentEventIndex : currentEventIndex + 1;

    const newParticipantProgress: GameEntity.ParticipantProgress = {
      currentEventIndex: newEventIndex,
      currentMonthForParticipant,
      status: shouldCompleteMonth ? 'month_result' : 'player_move',
      monthResults,
      progress: GameTargetEntity.calculateProgress(game, this.userId),
    };

    return produce(game, (draft) => {
      draft.state.participantsProgress[this.userId] = newParticipantProgress;
    });
  }
}
