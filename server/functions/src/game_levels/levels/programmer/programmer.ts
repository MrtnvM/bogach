import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const ProgrammerLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Когда все под контролем',
  icon: template.icon,
  image: template.image,
  template: template,
  monthLimit: 12,
  levelEventConfig: eventConfig,
};
