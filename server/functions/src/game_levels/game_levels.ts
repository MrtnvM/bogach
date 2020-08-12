import { GameLevelsConfig } from './models/game_levels_config';
import { HookahManLevel } from './levels/hookah_man/hookah_man';

export const GameLevels: GameLevelsConfig = {
  gameLevelsIds: [HookahManLevel.id],
  levelsMap: {
    [HookahManLevel.id]: HookahManLevel,
  },
};
