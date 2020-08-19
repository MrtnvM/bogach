import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const ProgrammerLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Всего 180 000 до свадьбы',
  icon: template.icon,
  template: template,
  monthLimit: 12,
  levelEventConfig: eventConfig,
};
