import { blackBmwTemplate } from './black_bmw/black_bmw_template';
import { GameTemplatesConfig } from './models/game_templates_config';
import { courierTemplate } from './courier/courier_template';
import { guyGrewUpTemplate } from './guy_grew_up/guy_grew_up';
import { firstStepsTemplate } from './first_steps/first_steps_template';
import { managerTemplate } from './manager/manager_template';

export const GameTemplates: GameTemplatesConfig = {
  gameTemplatesIds: [
    firstStepsTemplate.id,
    guyGrewUpTemplate.id,
    blackBmwTemplate.id,
    courierTemplate.id,
    managerTemplate.id,
  ],
  templatesMap: {
    [firstStepsTemplate.id]: firstStepsTemplate,
    [guyGrewUpTemplate.id]: guyGrewUpTemplate,
    [blackBmwTemplate.id]: blackBmwTemplate,
    [courierTemplate.id]: courierTemplate,
    [managerTemplate.id]: managerTemplate,
  },
};
