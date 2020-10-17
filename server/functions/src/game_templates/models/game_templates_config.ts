import { GameTemplate, GameTemplateEntity } from "./game_template";
import { Entity } from "../../core/domain/entity";

export interface GameTemplatesConfig {
    readonly templatesMap: { [templateId: string]: GameTemplate };
    readonly gameTemplatesIds: GameTemplateEntity.Id[];
  }
  
  export namespace GameLevelsConfigEntity {
    export const validate = (config: any) => {
      const entity = Entity.createEntityValidator<GameTemplatesConfig>(config, 'GameTemplatesConfig');
  
      entity.hasValue('templatesMap');
      entity.hasArrayValue('gameTemplatesIds');

      const templatesConfig = config as GameTemplatesConfig;
    
      templatesConfig.gameTemplatesIds.forEach((id) =>
        GameTemplateEntity.validate(templatesConfig.templatesMap[id])
      );
    };
  }