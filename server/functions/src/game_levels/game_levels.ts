import { GameLevelsConfig } from './models/game_levels_config';
import { HookahManLevel } from './levels/hookah_man/hookah_man';
import { PsychologistLevel } from './levels/psychologist/psychologist';
import { ProgrammerLevel } from './levels/programmer/programmer';

export const GameLevels: GameLevelsConfig = {
  gameLevelsIds: [HookahManLevel.id, PsychologistLevel.id, ProgrammerLevel.id],
  levelsMap: {
    [HookahManLevel.id]: HookahManLevel,
    [PsychologistLevel.id]: PsychologistLevel,
    [ProgrammerLevel.id]: ProgrammerLevel,
  },
};
