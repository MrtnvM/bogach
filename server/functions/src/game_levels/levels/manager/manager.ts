import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const ManagerLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Накопить 290 000 на ремонт квартиры',
  icon: template.icon,
  template: template,
  monthLimit: 14,
  levelEventConfig: eventConfig,
};
