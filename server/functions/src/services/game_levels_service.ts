/// <reference types="@types/node"/>

import * as fs from 'fs';
import * as path from 'path';

import { GameLevel } from '../models/domain/game_levels/game_level';
import {
  GameLevelConfigEntity,
  GameLevelConfig,
} from '../models/domain/game_levels/game_level_config';

let gameLevelsConfigCache: GameLevelConfig;

export class GameLevelsService {
  getGameLevels(): GameLevel[] {
    const config = this.getGameLevelsConfig();
    return config.gameLevels;
  }

  private getGameLevelsConfig(): GameLevelConfig {
    if (gameLevelsConfigCache) {
      return gameLevelsConfigCache;
    }

    const gameLevelsConfigPath = path.join(
      this.getGameLevelsFolderPath(),
      'game_levels_config.json'
    );

    const rawData = fs.readFileSync(gameLevelsConfigPath, 'utf8');
    const gameLevelsConfig = JSON.parse(rawData) as GameLevelConfig;
    GameLevelConfigEntity.validate(gameLevelsConfig);

    gameLevelsConfigCache = gameLevelsConfig;
    return gameLevelsConfig;
  }

  private getGameLevelsFolderPath() {
    return path.join(__dirname, '..', '..', 'data', 'game_levels');
  }
}
