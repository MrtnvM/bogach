/// <reference types="@types/jest"/>

import { GameLevelsProvider } from './game_levels_provider';
import { GameLevelConfigEntity } from '../models/domain/game_levels/game_level_config';

describe('Game Levels Service', () => {
  test('Successfully load game levels', () => {
    const gameLevelsService = new GameLevelsProvider();
    const gameLevels = gameLevelsService.getGameLevels();

    expect(gameLevels.length).toBeGreaterThan(0);
  });

  test('Check game level configs', () => {
    const gameLevelsService = new GameLevelsProvider();
    const gameLevels = gameLevelsService.getGameLevels();

    gameLevels.forEach((level) => {
      const levelConfig = gameLevelsService.getGameLevelConfig(level.id);
      GameLevelConfigEntity.validate(levelConfig);
    });
  });
});
