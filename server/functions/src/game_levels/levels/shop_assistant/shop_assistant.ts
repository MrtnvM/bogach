import { template } from './game_template';
import { eventConfig } from './event_config';
import { GameLevel } from '../../models/game_level';

export const ShopAssistantLevel: GameLevel = {
  id: template.id,
  name: template.name,
  description: 'Разбираешься во всем, чем можешь',
  icon: template.icon,
  image: template.image,
  template,
  monthLimit: 9,
  levelEventConfig: eventConfig,
};
