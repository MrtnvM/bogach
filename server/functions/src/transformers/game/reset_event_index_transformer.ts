import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user/user';

export class ResetEventIndexTransformer extends GameTransformer {
  constructor(private userId: UserEntity.Id) {
    super();
  }

  apply(game: Game): Game {
    const updatedGame = produce(game, (draft) => {
      const participant = draft.participants[this.userId];

      participant.progress.currentEventIndex = 0;
      participant.progress.currentMonthForParticipant = draft.state.monthNumber;
      participant.progress.status = 'player_move';
    });

    return updatedGame;
  }
}
