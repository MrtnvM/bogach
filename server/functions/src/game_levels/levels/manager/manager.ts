import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const ManagerLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Тебе повезло! Ты работаешь в офисе!',
  icon: template.icon,
  image: template.image,
  template: template,
  monthLimit: 14,
  levelEventConfig: eventConfig,
};
