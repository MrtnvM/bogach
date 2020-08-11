import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const PsychologistLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Всего 100 000 до авто мечты',
  icon: template.icon,
  template,
  monthLimit: 10,
  levelEventConfig: eventConfig,
};
