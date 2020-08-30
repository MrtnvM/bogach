import { GameLevelsConfig } from './models/game_levels_config';
import { HookahManLevel } from './levels/hookah_man/hookah_man';
import { PsychologistLevel } from './levels/psychologist/psychologist';
import { ProgrammerLevel } from './levels/programmer/programmer';
import { ManagerLevel } from './levels/manager/manager';

export const GameLevels: GameLevelsConfig = {
  gameLevelsIds: [HookahManLevel.id, PsychologistLevel.id, ProgrammerLevel.id, ManagerLevel.id],
  levelsMap: {
    [HookahManLevel.id]: HookahManLevel,
    [PsychologistLevel.id]: PsychologistLevel,
    [ProgrammerLevel.id]: ProgrammerLevel,
    [ManagerLevel.id]: ManagerLevel,
  },
};
