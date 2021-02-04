/// <reference types="@types/jest"/>

import { GameFixture } from '../../core/fixtures/game_fixture';
import { StockEventGenerator } from './stock_event_generator';

describe('Stock event generator', () => {
  test('Successfully generate stock event', async () => {
      const game = GameFixture.createGame({state: {
        gameStatus: 'players_move',
        monthNumber: 47,
        moveStartDateInUTC: new Date().toISOString(),
        winners: [],
      }});

      const event = StockEventGenerator.generate(game);
      expect(event !== undefined);
  });
})