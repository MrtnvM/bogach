/// <reference types="@types/node"/>

import * as fs from 'fs';
import * as path from 'path';

import { GameLevel } from '../models/domain/game_levels/game_level';
import {
  GameLevelConfig,
  GameLevelConfigEntity,
} from '../models/domain/game_levels/game_level_config';
import {
  GameLevelsConfigEntity,
  GameLevelsConfig,
} from '../models/domain/game_levels/game_levels_config';

let gameLevelsConfigCache: GameLevelsConfig;
let gameLevelConfigCache: { [levelId: string]: GameLevelConfig } = {};

export class GameLevelsService {
  getGameLevels(): GameLevel[] {
    const config = this.getGameLevelsConfig();
    return config.gameLevels;
  }

  getGameLevelConfig(gameLevelId: string): GameLevelConfig {
    const cachedGameLevelConfig = gameLevelConfigCache[gameLevelId];

    if (cachedGameLevelConfig) {
      return cachedGameLevelConfig;
    }

    const gameLevelConfigPath = path.join(
      this.getGameLevelsFolderPath(),
      'levels',
      `${gameLevelId}.json`
    );

    const rawData = fs.readFileSync(gameLevelConfigPath, 'utf8');
    const gameLevelConfig = JSON.parse(rawData) as GameLevelConfig;
    GameLevelConfigEntity.validate(gameLevelConfig);

    gameLevelConfigCache[gameLevelId] = gameLevelConfig;
    return gameLevelConfig;
  }

  private getGameLevelsConfig(): GameLevelsConfig {
    if (gameLevelsConfigCache) {
      return gameLevelsConfigCache;
    }

    const gameLevelsConfigPath = path.join(
      this.getGameLevelsFolderPath(),
      'game_levels_config.json'
    );

    const rawData = fs.readFileSync(gameLevelsConfigPath, 'utf8');
    const gameLevelsConfig = JSON.parse(rawData) as GameLevelsConfig;
    GameLevelsConfigEntity.validate(gameLevelsConfig);

    gameLevelsConfigCache = gameLevelsConfig;
    return gameLevelsConfig;
  }

  private getGameLevelsFolderPath() {
    return path.join(__dirname, '..', '..', 'data', 'game_levels');
  }
}
