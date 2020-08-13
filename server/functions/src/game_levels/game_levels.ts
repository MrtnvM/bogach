import { GameLevelsConfig } from './models/game_levels_config';
import { HookahManLevel } from './levels/hookah_man/hookah_man';
import { PsychologistLevel } from './levels/psychologist/psychologist';

export const GameLevels: GameLevelsConfig = {
  gameLevelsIds: [HookahManLevel.id, PsychologistLevel.id],
  levelsMap: {
    [HookahManLevel.id]: HookahManLevel,
    [PsychologistLevel.id]: PsychologistLevel,
  },
};
