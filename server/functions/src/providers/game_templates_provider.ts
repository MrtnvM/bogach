import { GameTemplate, GameTemplateEntity } from "../game_templates/models/game_template";
import { GameTemplates } from "../game_templates/game_templates";

export class GameTemplatesProvider {
    getGameTemplates(): GameTemplate[] {
      return GameTemplates.gameTemplatesIds.map((id) => GameTemplates.templatesMap[id]);
    }
  
    getGameTemplate(gameTemplateId: GameTemplateEntity.Id): GameTemplate {
      const template = GameTemplates.templatesMap[gameTemplateId];
      return template
    }
  }
  