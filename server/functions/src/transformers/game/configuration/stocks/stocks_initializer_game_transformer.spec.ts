/// <reference types="@types/jest"/>

import { StocksInitializerGameTransformer } from './stocks_initializer_game_transformer';
import { GameFixture } from '../../../../core/fixtures/game_fixture';

describe('Stocks Game Initializer Transformer', () => {
  test('', () => {
    const initializer = new StocksInitializerGameTransformer();
    const game = GameFixture.createGame();

    const newGame = initializer.apply(game);

    expect(newGame.config.stocks).not.toBeFalsy();
    expect(newGame.config.stocks.length).toBeGreaterThan(0);
  });
});
