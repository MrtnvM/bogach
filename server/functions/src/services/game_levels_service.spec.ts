/// <reference types="@types/jest"/>

import { GameLevelsService } from './game_levels_service';

describe('Game Levels Service', () => {
  test('Successfully load game levels', () => {
    const gameLevelsService = new GameLevelsService();
    const gameLevels = gameLevelsService.getGameLevels();

    expect(gameLevels.length).toBeGreaterThan(0);
  });
});
