import { Possessions, PossessionsEntity } from '../possessions';
import { Entity } from '../../../core/domain/entity';
import { Account, AccountEntity } from '../account';
import { GameTarget, GameTargetEntity } from './game_target';

export interface GameTemplate {
  readonly id: GameTemplateEntity.Id;
  readonly name: string;
  readonly possessions: Possessions;
  readonly accountState: Account;
  readonly target: GameTarget;
}

export namespace GameTemplateEntity {
  export type Id = string;

  export const parse = (data: any): GameTemplate => {
    const { id, name, possessions, accountState, target } = data;

    let gameTemplate: GameTemplate = {
      id,
      name,
      possessions,
      accountState,
      target,
    };

    validate(gameTemplate);
    return gameTemplate;
  };

  export const validate = (gameTemplate: any) => {
    const entity = Entity.createEntityValidator<GameTemplate>(gameTemplate, 'Game Template');

    entity.hasValue('id');
    entity.hasValue('name');
    entity.hasValue('possessions');
    entity.hasValue('accountState');
    entity.hasValue('target');

    const gameTemplateEntity = gameTemplate as GameTemplate;

    GameTargetEntity.validate(gameTemplateEntity.target);
    PossessionsEntity.validate(gameTemplateEntity.possessions);
    AccountEntity.validate(gameTemplateEntity.accountState);
  };
}
