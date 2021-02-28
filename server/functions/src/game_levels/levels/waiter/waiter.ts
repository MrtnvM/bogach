import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const WaiterLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Привык кидать вызов самому себе',
  icon: template.icon,
  image: template.image,
  template,
  monthLimit: 8,
  levelEventConfig: eventConfig,
};
