import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const HookahManLevel: GameLevel = {
  id: 'hookah_man',
  name: 'Кальянщик',
  icon:
    'https://st2.depositphotos.com/1504872/8305/v/450/depositphotos_83059322-stock-illustration-%D0%BA%D0%B0%D0%BB%D1%8C%D1%8F%D0%BD-%D1%8D%D1%81%D0%BA%D0%B8%D0%B7-%D0%B8%D0%BB%D0%BB%D1%8E%D1%81%D1%82%D1%80%D0%B0%D1%86%D0%B8%D1%8F.jpg',
  template,
  monthLimit: 7,
  levelEventConfig: eventConfig,
};
