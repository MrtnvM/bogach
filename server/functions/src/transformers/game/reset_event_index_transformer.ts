import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user';

export class ResetEventIndexTransformer extends GameTransformer {
  constructor(private userId: UserEntity.Id) {
    super();
  }

  apply(game: Game): Game {
    const updatedGame = produce(game, (draft) => {
      const progress = draft.state.participantsProgress[this.userId];

      progress.currentEventIndex = 0;
      progress.currentMonthForParticipant = draft.state.monthNumber;
      progress.status = 'player_move';
    });

    return updatedGame;
  }
}
