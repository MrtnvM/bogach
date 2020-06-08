import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { GameTransformer } from './game_transformer';
import { UserEntity } from '../../models/domain/user';

export class MonthResultTransformer extends GameTransformer {
  constructor(private userId: UserEntity.Id) {
    super();
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const participantProgress = game.state.participantsProgress[this.userId];
    const isMonthResult = participantProgress.status === 'month_result';

    if (!isMonthResult) {
      return game;
    }

    return produce(game, (draft) => {
      const monthResults = draft.state.participantsProgress[this.userId].monthResults;

      draft.state.participantsProgress[this.userId].monthResults = {
        ...monthResults,
        [game.state.monthNumber - 1]: {
          cash: game.accounts[this.userId].cash,
        },
      };
    });
  }
}
