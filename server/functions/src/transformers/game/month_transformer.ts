import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { GameTransformer } from './game_transformer';

export class MonthTransformer extends GameTransformer {
  transformerContext() {
    return { name: 'MonthTransformer' };
  }

  apply(game: Game): Game {
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);

    if (!isMoveCompleted) {
      return game;
    }

    const firstParticipantId = game.participantsIds[0];
    const firstParticipant = game.participants[firstParticipantId];
    const currentMonth = firstParticipant.progress.currentMonthForParticipant;
    const monthNumber = currentMonth + 1;

    return produce(game, (draft) => {
      draft.state.monthNumber = monthNumber;
    });
  }
}
