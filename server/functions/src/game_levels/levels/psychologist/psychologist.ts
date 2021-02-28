import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const PsychologistLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Холодный расчет, взвешенные решения',
  icon: template.icon,
  image: template.image,
  template,
  monthLimit: 10,
  levelEventConfig: eventConfig,
};
