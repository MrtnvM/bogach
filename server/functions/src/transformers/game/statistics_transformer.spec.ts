/// <reference types="@types/jest"/>

import { LevelStatistic } from '../../models/domain/level_statistic/level_statistic';
import { StatisticsTransformer } from './statistics_transformer';
import { GameFixture } from '../../core/fixtures/game_fixture';
import produce from 'immer';

describe('Statistics Transformer Tests', () => {
  const userId = 'current_user';

  const statistics = (months: number[]): LevelStatistic => ({
    id: 'level1',
    statistic: new Map<string, number>(months.map((month, index) => [`user${index}`, month])),
  });

  const createGame = (currentMonth: number) => {
    const game = produce(GameFixture.createGame({ participantsIds: [userId] }), (draft) => {
      draft.state.winners[0] = {
        userId,
        targetValue: 0,
        benchmark: 0,
      };

      draft.state.monthNumber = currentMonth;
    });

    return game;
  };

  test('No benchamark if no data', async () => {
    const statistic1 = statistics([]);
    const transformer = new StatisticsTransformer(statistic1, userId);
    const game = createGame(1);

    const newGame = transformer.apply(game);

    expect(newGame.state.winners[0].benchmark).toBe(0);
  });

  test('No benchamark if not enough data', async () => {
    const statistic1 = statistics([10, 12, 8, 9]);
    const transformer = new StatisticsTransformer(statistic1, userId);
    const game = createGame(1);

    const newGame = transformer.apply(game);

    expect(newGame.state.winners[0].benchmark).toBe(0);
  });

  test('Benchamark calculated correctly - equal to 0', async () => {
    const currentMonth = 13;
    const statistic1 = statistics([10, 12, 8, 9, 10]);
    statistic1.statistic.set(userId, currentMonth);
    const transformer = new StatisticsTransformer(statistic1, userId);
    const game = createGame(currentMonth);

    const newGame = transformer.apply(game);

    expect(newGame.state.winners[0].benchmark).toBe(0);
  });

  test('Benchamark calculated correctly', async () => {
    const currentMonth = 9;
    const statistic1 = statistics([10, 12, 8, 9, 10, 16, 11]);
    statistic1.statistic.set(userId, currentMonth);
    const transformer = new StatisticsTransformer(statistic1, userId);
    const game = createGame(currentMonth);

    const newGame = transformer.apply(game);

    expect(newGame.state.winners[0].benchmark).toBe(75);
  });

  test('Benchamark calculated correctly for best result', async () => {
    const currentMonth = 8;
    const statistic1 = statistics([10, 12, 8, 9, 10, 16, 11]);
    statistic1.statistic.set(userId, currentMonth);
    const transformer = new StatisticsTransformer(statistic1, userId);
    const game = createGame(currentMonth);

    const newGame = transformer.apply(game);

    expect(newGame.state.winners[0].benchmark).toBe(100);
  });
});
