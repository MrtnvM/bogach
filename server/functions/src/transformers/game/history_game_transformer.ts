import { produce } from 'immer';

import { GameTransformer } from './game_transformer';
import { Game, GameEntity } from '../../models/domain/game/game';

export class HistoryGameTransformer extends GameTransformer {
  constructor() {
    super();
  }

  apply(game: Game): Game {
    const isGameCompleted = game.state.gameStatus === 'game_over';
    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const historyMonthIndex = Math.max(game.state.monthNumber - 1, 0);

    const months = game.history?.months || [];
    const isHistoryAlreadyUpdated = months[historyMonthIndex]?.events !== undefined;

    if (isGameCompleted || !isMoveCompleted || isHistoryAlreadyUpdated) {
      return game;
    }

    return produce(game, (draft) => {
      const history: GameEntity.History = draft.history || { months: [] };
      history.months[historyMonthIndex] = { events: game.currentEvents };

      draft.history = history;
    });
  }
}
