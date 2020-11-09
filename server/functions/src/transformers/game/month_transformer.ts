import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { GameTransformer } from './game_transformer';

export class MonthTransformer extends GameTransformer {
  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    if (!isMoveCompleted) {
      return game;
    }

    const firstParticipant = game.participants[0];
    const currentMonth = firstParticipant.progress.currentMonthForParticipant;
    const monthNumber = currentMonth + 1;

    return produce(game, (draft) => {
      draft.state.monthNumber = monthNumber;
    });
  }
}
