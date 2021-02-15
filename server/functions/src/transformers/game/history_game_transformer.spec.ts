/// <reference types="@types/jest"/>

import { HistoryGameTransformer } from './history_game_transformer';
import { history, rules, expectedHistory } from './history_game_transformer.spec.utils';

describe('Game Events Transformer', () => {
  test('Successfully clear useless history events', async () => {
    const historyTransformer = new HistoryGameTransformer();
    const newHistory = historyTransformer.getFilteredHistoryEvents(history, rules);

    expect(newHistory).toEqual(expectedHistory);
  });
});
