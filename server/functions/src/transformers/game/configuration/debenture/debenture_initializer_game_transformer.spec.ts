/// <reference types="@types/jest"/>

import { DebentureInitializerGameTransformer } from './debenture_initializer_game_transformer';
import { GameFixture } from '../../../../core/fixtures/game_fixture';

describe('Debenture Game Initializer Transformer', () => {
  test('', () => {
    const initializer = new DebentureInitializerGameTransformer();
    const game = GameFixture.createGame();

    const newGame = initializer.apply(game);

    expect(newGame.config.debentures).not.toBeFalsy();
    expect(newGame.config.debentures.length).toBeGreaterThan(0);
  });
});
