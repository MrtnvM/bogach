import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { GameTransformer } from './game_transformer';

export class MonthResultTransformer extends GameTransformer {
  constructor(private force: boolean = false) {
    super();
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    return produce(game, (draft) => {
      draft.participants.forEach((participantId) => {
        const participantProgress = game.state.participantsProgress[participantId];
        const isMonthResult = participantProgress.status === 'month_result';

        if (!isMonthResult && !this.force) {
          return;
        }

        const monthResults = draft.state.participantsProgress[participantId].monthResults;
        const resultMonth = game.state.monthNumber - 1;
        const resultAlreadyExists = monthResults[resultMonth] !== undefined;

        if (resultAlreadyExists) {
          return;
        }

        draft.state.participantsProgress[participantId].monthResults[resultMonth] = {
          cash: game.accounts[participantId].cash,
        };
      });
    });
  }
}
