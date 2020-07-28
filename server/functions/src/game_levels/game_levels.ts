import { GameLevelsConfig } from './models/game_levels_config';
import { HookahManLevel } from './levels/hookah_man/hookah_man';

export const GameLevels: GameLevelsConfig = {
  gameLevelsIds: [HookahManLevel.id],
  levelsMap: {
    hookah_man: HookahManLevel,
    // dancing_trainer: {
    //   id: 'dancing_trainer',
    //   name: 'Тренер по танцам',
    //   icon:
    //     'https://thumbs.dreamstime.com/b/%D0%B7%D0%BD%D0%B0%D1%87%D0%BE%D0%BA-%D0%BA%D0%B0%D1%81%D1%81%D1%8B-%D0%B2-%D1%81%D1%82%D0%B8-%D0%B5-%D0%BF-%D0%B0%D0%BD%D0%B0-%D0%B8%D0%B7%D0%BE-%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D0%B9-%D0%BD%D0%B0-%D0%B1%D0%B5-%D0%BE%D0%B9-%D0%BF%D1%80%D0%B5-%D0%BF%D0%BE%D1%81%D1%8B-%D0%BA%D0%B5-83949376.jpg',
    //   config: HookahManLevel,
    // },
  },
};
