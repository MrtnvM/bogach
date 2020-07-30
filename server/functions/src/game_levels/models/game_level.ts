import { Entity } from '../../core/domain/entity';
import { GameTemplate, GameTemplateEntity } from '../../models/domain/game/game_template';
import { GameLevelEventConfig } from './event_config';

export interface GameLevel {
  readonly id: GameLevelEntity.Id;
  readonly name: string;
  readonly icon: string;
  readonly template: GameTemplate;
  readonly levelEventConfig: GameLevelEventConfig;

  /// Max month count in game.
  /// When limit is crossed game should be completed
  readonly monthLimit: number;
}

export namespace GameLevelEntity {
  export type Id = string;

  export const validate = (gameLevel: any) => {
    const entity = Entity.createEntityValidator<GameLevel>(gameLevel, 'Game Level');

    entity.hasStringValue('id');
    entity.hasStringValue('name');
    entity.hasStringValue('icon');
    entity.hasObjectValue('template', GameTemplateEntity.validate);
    entity.hasValue('levelEventConfig');
    entity.hasNumberValue('monthLimit');

    entity.checkWithRules([
      [(l) => l.monthLimit <= 0, 'Month limit can not be lower or equal zero'],
    ]);
  };
}
