import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const WaiterLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Накопить на новый телефон',
  icon: template.icon,
  template,
  monthLimit: 8,
  levelEventConfig: eventConfig,
};
