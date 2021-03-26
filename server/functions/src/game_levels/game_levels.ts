import { GameLevelsConfig } from './models/game_levels_config';
import { HookahManLevel } from './levels/hookah_man/hookah_man';
import { PsychologistLevel } from './levels/psychologist/psychologist';
import { ProgrammerLevel } from './levels/programmer/programmer';
import { ManagerLevel } from './levels/manager/manager';
import { WaiterLevel } from './levels/waiter/waiter';
import { ShopAssistantLevel } from './levels/shop_assistant/shop_assistant';

export const GameLevels: GameLevelsConfig = {
  gameLevelsIds: [
    HookahManLevel.id,
    WaiterLevel.id,
    ShopAssistantLevel.id,
    PsychologistLevel.id,
    ProgrammerLevel.id,
    ManagerLevel.id,
  ],
  levelsMap: {
    [HookahManLevel.id]: HookahManLevel,
    [WaiterLevel.id]: WaiterLevel,
    [ShopAssistantLevel.id]: ShopAssistantLevel,
    [PsychologistLevel.id]: PsychologistLevel,
    [ProgrammerLevel.id]: ProgrammerLevel,
    [ManagerLevel.id]: ManagerLevel,
  },
};
