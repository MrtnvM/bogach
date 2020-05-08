import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { GameTransformer } from './game_transformer';

export class MonthTransformer extends GameTransformer {
  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const monthNumber = game.state.monthNumber + (isMoveCompleted ? 1 : 0);

    return produce(game, (draft) => {
      draft.state.monthNumber = monthNumber;
    });
  }
}
