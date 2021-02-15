/// <reference types="@types/jest"/>

import { GameFixture } from '../../../core/fixtures/game_fixture';
import { GameEntity } from './game';
import { GameMinifier } from './game_minifier';

describe('Game Minifier', () => {
  test('Game 1', () => {
    const initialGame = GameFixture.createGame();
    const initialGameJson = JSON.stringify(initialGame, null, 2);

    const minifiedGame = GameMinifier.minify(initialGame);
    const normalizedGame = GameMinifier.normalize(minifiedGame);
    const normalizedGameJson = JSON.stringify(normalizedGame, null, 2);

    expect(normalizedGameJson).toEqual(initialGameJson);
  });

  test('Game 2', () => {
    const initialGame = require('./game.json');
    GameEntity.validate(initialGame);
    const initialGameJson = JSON.stringify(initialGame, null, 2);

    const minifiedGame = GameMinifier.minify(initialGame);
    const normalizedGame = GameMinifier.normalize(minifiedGame);
    const normalizedGameJson = JSON.stringify(normalizedGame, null, 2);

    expect(normalizedGameJson).toEqual(initialGameJson);
  });
});
