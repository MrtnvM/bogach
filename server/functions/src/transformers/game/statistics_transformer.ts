import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import produce from 'immer';
import { UserEntity } from '../../models/domain/user/user';
import { LevelStatistic } from '../../models/domain/level_statistic/level_statistic';

export class StatisticsTransformer extends GameTransformer {
  constructor(private statistics: LevelStatistic, private userId: UserEntity.Id) {
    super();
  }

  transformerContext() {
    return { name: 'StatisticsTransformer' };
  }

  apply(game: Game): Game {
    const currentUserResult = game.state.monthNumber;

    const allResults = [...this.statistics.statistic.keys()]
      .map((userId) => this.statistics.statistic.get(userId) as number)
      .sort((result1, result2) => result1 - result2);

    if (allResults.length <= 4) {
      return game;
    }

    if (currentUserResult <= allResults[0]) {
      return produce(game, (draft) => {
        const winnerIndex = draft.state.winners.findIndex((w) => w.userId === this.userId);

        if (winnerIndex >= 0) {
          draft.state.winners[winnerIndex].benchmark = 100;
        }
      });
    }

    const currentUserResultIndex = allResults.findIndex((result) => result >= currentUserResult);

    if (currentUserResultIndex < 0) {
      return game;
    }

    const benchmark =
      ((allResults.length - (currentUserResultIndex + 1)) / allResults.length) * 100;

    return produce(game, (draft) => {
      const winnerIndex = draft.state.winners.findIndex((w) => w.userId === this.userId);

      if (winnerIndex >= 0) {
        draft.state.winners[winnerIndex].benchmark = benchmark;
      }
    });
  }
}
