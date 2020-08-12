import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const HookahManLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Накопить на PS4 за 7 месяцев',
  icon: template.icon,
  template,
  monthLimit: 7,
  levelEventConfig: eventConfig,
};
