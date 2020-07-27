/// <reference types="@types/jest"/>

import { GameLevelsProvider } from './game_levels_provider';
import { GameLevelEntity } from '../models/domain/game_levels/game_level';

describe('Game Levels Service', () => {
  test('Successfully load game levels', () => {
    const gameLevelsService = new GameLevelsProvider();
    const gameLevels = gameLevelsService.getGameLevels();

    expect(gameLevels.length).toBeGreaterThan(0);
  });

  test('Check game level configs', () => {
    const gameLevelsService = new GameLevelsProvider();
    const gameLevels = gameLevelsService.getGameLevels();
    gameLevels.forEach(GameLevelEntity.validate);
  });
});
