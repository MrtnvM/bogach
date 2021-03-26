import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const HookahManLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Для тех кто уверен в себе',
  icon: template.icon,
  image: template.image,
  template,
  monthLimit: 7,
  levelEventConfig: eventConfig,
};
