import { blackBmwTemplate } from './black_bmw/black_bmw_template';
import { GameTemplatesConfig } from './models/game_templates_config';
import { courierTemplate } from './courier/courier_template';

export const GameTemplates: GameTemplatesConfig = {
  gameTemplatesIds: [blackBmwTemplate.id, courierTemplate.id],
  templatesMap: {
    [blackBmwTemplate.id]: blackBmwTemplate,
    [courierTemplate.id]: courierTemplate,
  },
};
